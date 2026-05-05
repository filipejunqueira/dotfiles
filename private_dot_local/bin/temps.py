#!/usr/bin/env python3
"""temps: read CPU / iGPU / dGPU temps with cached, name-resolved sysfs paths.

Importable as a module:
    from temps import TempReader
    reader = TempReader()
    sample = reader.read()

Runnable for testing:
    python3 temps.py            # one read
    python3 temps.py --loop 5   # five reads with timing
"""
from __future__ import annotations

import argparse
import subprocess
import time
from dataclasses import dataclass, field
from pathlib import Path

HWMON = Path("/sys/class/hwmon")
PCI = Path("/sys/bus/pci/devices")

NVIDIA_VENDOR = "0x10de"
DISPLAY_CLASS_PREFIX = "0x030"  # 0x030000 VGA, 0x030200 3D controller

NVIDIA_SMI_TIMEOUT_S = 2.0  # generous; cold start can be ~500ms


def _read(p: Path) -> str | None:
    """Read a sysfs file; return None on any error."""
    try:
        return p.read_text().strip()
    except (OSError, FileNotFoundError):
        return None


@dataclass
class Sample:
    """One thermal reading. Any field may be None if unavailable."""
    ts: float
    cpu: float | None = None
    igpu: float | None = None
    dgpu: float | None = None
    dgpu_state: str | None = None  # 'active', 'suspended', 'absent', 'error'
    errors: list[str] = field(default_factory=list)

    def as_dict(self) -> dict:
        return {
            "ts": self.ts,
            "cpu": self.cpu,
            "igpu": self.igpu,
            "dgpu": self.dgpu,
            "dgpu_state": self.dgpu_state,
            "errors": self.errors,
        }


class TempReader:
    """Reads CPU/iGPU/dGPU temps. Caches sysfs paths by hwmon `name`.

    Cache invalidates automatically when a cached path fails to read,
    handling kernel module reloads where hwmonN numbering changes.
    """

    def __init__(self) -> None:
        self._cpu_path: Path | None = None
        self._igpu_path: Path | None = None
        self._dgpu_pci: Path | None = None

    # ---- path resolution ----

    @staticmethod
    def _find_hwmon_temp(name: str, label: str | None = None) -> Path | None:
        """Find the temp*_input file for the hwmon device whose name matches.

        If label is given, match the temp whose temp*_label equals it;
        otherwise return the first temp*_input found.
        """
        if not HWMON.exists():
            return None
        for hw in sorted(HWMON.iterdir()):
            if _read(hw / "name") != name:
                continue
            inputs = sorted(hw.glob("temp*_input"))
            if not inputs:
                return None
            if label is None:
                return inputs[0]
            for inp in inputs:
                stem = inp.name.removesuffix("_input")
                if _read(hw / f"{stem}_label") == label:
                    return inp
            return None
        return None

    @staticmethod
    def _find_nvidia_pci() -> Path | None:
        """Find the PCI device path for an NVIDIA display controller."""
        if not PCI.exists():
            return None
        for dev in sorted(PCI.iterdir()):
            if (
                _read(dev / "vendor") == NVIDIA_VENDOR
                and (_read(dev / "class") or "").startswith(DISPLAY_CLASS_PREFIX)
            ):
                return dev
        return None

    # ---- individual reads ----

    def _read_hwmon(
        self,
        cached: Path | None,
        name: str,
        label: str | None,
    ) -> tuple[float | None, Path | None, str | None]:
        """Read a hwmon temp; re-resolve on failure. Returns (temp_c, path, error)."""
        path = cached or self._find_hwmon_temp(name, label)
        if path is None:
            return None, None, f"{name}: not found"
        raw = _read(path)
        if raw is None or not raw.lstrip("-").isdigit():
            # Cached path went stale — try once more from scratch
            fresh = self._find_hwmon_temp(name, label)
            if fresh is not None and fresh != path:
                raw = _read(fresh)
                if raw is not None and raw.lstrip("-").isdigit():
                    return int(raw) / 1000.0, fresh, None
            return None, None, f"{name}: unreadable ({raw!r})"
        return int(raw) / 1000.0, path, None

    def _read_dgpu(self) -> tuple[float | None, str, str | None]:
        """Read dGPU temp. Returns (temp_c, state, error).

        State is one of: 'active', 'suspended', 'absent', 'error'.
        Only invokes nvidia-smi when state == 'active'.
        """
        if self._dgpu_pci is None:
            self._dgpu_pci = self._find_nvidia_pci()
        if self._dgpu_pci is None:
            return None, "absent", None

        status = _read(self._dgpu_pci / "power" / "runtime_status") or "unknown"
        if status == "suspended":
            return None, "suspended", None
        # 'active' or anything else — try nvidia-smi
        try:
            result = subprocess.run(
                [
                    "nvidia-smi",
                    "--query-gpu=temperature.gpu",
                    "--format=csv,noheader,nounits",
                ],
                capture_output=True,
                text=True,
                timeout=NVIDIA_SMI_TIMEOUT_S,
                check=False,
            )
        except subprocess.TimeoutExpired:
            return None, "error", "nvidia-smi: timeout"
        except FileNotFoundError:
            return None, "error", "nvidia-smi: not installed"
        if result.returncode != 0:
            return None, "error", f"nvidia-smi: rc={result.returncode}"
        first = (result.stdout or "").strip().splitlines()
        if not first or not first[0].strip().isdigit():
            return None, "error", f"nvidia-smi: bad output {first!r}"
        return float(first[0].strip()), status, None

    # ---- public API ----

    def read(self) -> Sample:
        sample = Sample(ts=time.time())

        cpu, self._cpu_path, err = self._read_hwmon(self._cpu_path, "k10temp", "Tctl")
        sample.cpu = cpu
        if err:
            sample.errors.append(err)

        igpu, self._igpu_path, err = self._read_hwmon(self._igpu_path, "amdgpu", "edge")
        sample.igpu = igpu
        if err:
            sample.errors.append(err)

        dgpu, state, err = self._read_dgpu()
        sample.dgpu = dgpu
        sample.dgpu_state = state
        if err:
            sample.errors.append(err)

        return sample


def _format(s: Sample) -> str:
    def f(v: float | None) -> str:
        return f"{v:5.1f}°C" if v is not None else "  --  "
    return (
        f"CPU {f(s.cpu)}  iGPU {f(s.igpu)}  "
        f"dGPU {f(s.dgpu)} ({s.dgpu_state})"
        + (f"  errors={s.errors}" if s.errors else "")
    )


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--loop", type=int, default=1, metavar="N",
                    help="take N samples 1s apart with timing (default: 1)")
    args = ap.parse_args()

    reader = TempReader()
    for i in range(args.loop):
        t0 = time.perf_counter()
        sample = reader.read()
        elapsed_ms = (time.perf_counter() - t0) * 1000
        print(f"[{i+1}/{args.loop}] {_format(sample)}  took {elapsed_ms:5.1f}ms")
        if i < args.loop - 1:
            time.sleep(1.0)


if __name__ == "__main__":
    main()
