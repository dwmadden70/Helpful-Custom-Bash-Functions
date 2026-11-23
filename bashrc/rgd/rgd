# -------------------------------------------------------------
# Custom function to find occurrence of word(s) using ripgrep
# -------------------------------------------------------------
rgd() {
    local help_file="$HOME/.rgd-usage.md"

    # 0: Help requested
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        if [[ -f "$help_file" ]]; then
            if command -v glow >/dev/null 2>&1; then
                glow "$help_file"
            elif command -v bat >/dev/null 2>&1; then
                bat --style=plain --language=markdown "$help_file"
            else
                sed -E 's/^#+ //g; s/\*\*([^*]+)\*\*/\1/g; s/`([^`]+)`/\1/g' "$help_file"
            fi
        else
            echo "Usage: rgd <filename_or_glob> <word1,word2,...> [search_directory]"
        fi
        return 0
    fi

    # 127: Missing dependency
    if ! command -v rg >/dev/null 2>&1; then
        echo "Warning: 'ripgrep' (rg) is not installed or not in your PATH." >&2
        echo "Install it first using your package manager:" >&2
        echo "  Ubuntu/Debian: sudo apt update && sudo apt install -y ripgrep" >&2
        echo "  Fedora:        sudo dnf install -y ripgrep" >&2
        echo "  Arch:          sudo pacman -S ripgrep" >&2
        return 127
    fi

    # 2: Invalid arguments / usage error
    if [[ "$#" -lt 2 || -z "$1" || -z "$2" ]]; then
        echo "Error: Missing or empty required arguments." >&2
        echo "Run 'rgd --help' for usage and examples." >&2
        return 2
    fi

    local file_glob="$1"
    local raw_terms="$2"
    local search_path="${3:-.}"

    # 3: Target directory does not exist
    if [[ ! -d "$search_path" ]]; then
        echo "Error: Directory '$search_path' does not exist." >&2
        return 3
    fi

    # Escape regex metacharacters, then turn commas into OR (|) operators
    local pattern
    pattern=$(printf '%s' "$raw_terms" | sed -e 's/[.[\*^$()+?{|\\]/\\&/g' -e 's/,/|/g')

    # Preserve colors and layout only when outputting directly to a terminal
    local format_flags=()
    if [[ -t 1 ]]; then
        format_flags=(--color=always --heading)
    fi

    # Execute ripgrep, strip blank lines, deduplicate, and indent matched lines by 4 spaces
    rg -nwi --no-ignore --no-follow "${format_flags[@]}" --iglob "$file_glob" -- "$pattern" "$search_path" 2>/dev/null \
        | awk 'NF && !seen[$0]++ { if ($0 ~ /^(\033\[[0-9;]*m)*[0-9]+(\033\[[0-9;]*m)*:/) print "    " $0; else print $0 }'
    local rg_status=${PIPESTATUS[0]}

    # Keep native exit status
    case "$rg_status" in
        0) return 0 ;; # Matches found
        1) return 1 ;; # No matches found
        *) return 4 ;; # Any ripgrep runtime/regex error (native code 2+)
    esac
}

_rgd_completions() {
    local cur="${COMP_WORDS[COMP_CWORD]}"

    case "$COMP_CWORD" in
        1)
            # 1st arg: suggest --help/-h if typing a flag, otherwise complete filenames
            if [[ "$cur" == -* ]]; then
                COMPREPLY=( $(compgen -W "--help -h" -- "$cur") )
            else
                COMPREPLY=( $(compgen -f -- "$cur") )
            fi
            ;;
        2)
            # 2nd arg: search word(s) ΓÇö return nothing so Bash doesn't clutter with random filenames
            COMPREPLY=()
            ;;
        3)
            # 3rd arg: complete directories only
            COMPREPLY=( $(compgen -d -- "$cur") )
            ;;
        *)
            COMPREPLY=()
            ;;
    esac
}

complete -o filenames -F _rgd_completions rgd
