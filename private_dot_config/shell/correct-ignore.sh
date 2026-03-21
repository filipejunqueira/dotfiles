# correct-ignore — persistent exclusion list for zsh CORRECT
# Usage: correct-ignore drift

correct-ignore() {
    local cmd="$1"
    local file="$HOME/.config/shell/correct-ignore-list"
    [[ -z "$cmd" ]] && { echo "Usage: correct-ignore <command>"; return 1; }
    if ! grep -qx "$cmd" "$file" 2>/dev/null; then
        echo "$cmd" >> "$file"
        alias "$cmd"="nocorrect $cmd"
        echo "Added '$cmd' to correction ignore list"
    else
        echo "'$cmd' already ignored"
    fi
}

# Load saved ignores at shell startup
if [[ -f "$HOME/.config/shell/correct-ignore-list" ]]; then
    while IFS= read -r cmd; do
        [[ -n "$cmd" ]] && alias "$cmd"="nocorrect $cmd"
    done < "$HOME/.config/shell/correct-ignore-list"
fi
