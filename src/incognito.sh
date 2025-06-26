#!/bin/env zsh

set -euo pipefail

VERSION="0.1.0"
VERBOSE=0

# Determine the history file location, defaulting to ~/.zsh_history
: "${HISTFILE:=$HOME/.zsh_history}"

# Set the marker file location based on the operating system and create the directory
case "$(uname -s)" in
    Darwin)
        MARKER_FILE="$HOME/Library/Application Support/incognito/marker"
        ;;
    Linux)
        MARKER_FILE="$HOME/.local/share/incognito/marker"
        ;;
    *)
        echo "Unsupported operating system: $(uname -s)"
        exit 1
        ;;
esac
mkdir -p "$(dirname "$MARKER_FILE")"

usage() {
    echo "Usage: incognito <command> [options]"
    echo ""
    echo "Commands:"
    echo "  enter    Enter incognito mode"
    echo "  exit     Exit incognito mode"
    echo "  help     Show this help message"
    echo "  setup    Prints the shell functions to exit incognito mode on shell exit"
    echo ""
    echo "Options:"
    echo "  -h, --help    Show this help message"
    echo ""
    echo "Examples:"
    echo "  incognito enter"
    echo "  incognito exit"
    echo ""
    echo "Exit incognito on shell exit:"
    echo "  Add this to your .zshrc: \"eval \"\$(incognito exit)\"\""
}

mark() {
    if [[ -f "$MARKER_FILE" ]]; then
        echo "You are already in incognito mode. Use \"incognito exit\" to leave."
        exit 1
    fi

    local MARKER="$(tail -n 1 "$HISTFILE")"

    if [[ -z "$MARKER" && "$VERBOSE" -eq 1 ]]; then
        echo "Empty history. The whole history will be cleared when exiting incognito mode."
        exit 1
    fi

    echo "$MARKER" > "$MARKER_FILE"
}

remove() {
    if [[ ! -f "$MARKER_FILE" ]]; then
        echo "Nothing to do. You are not in incognito mode."
        exit 1
    fi

    local MARKER=$(cat "$MARKER_FILE")

    if [[ -z "$MARKER" ]]; then
        if [[ "$VERBOSE" -eq 1 ]]; then
            echo "History was empty when entering incognito mode. Cleared whole history."
        fi

        echo "" > "$HISTFILE"
        rm -f "$MARKER_FILE"
        exit 0
    fi

    local LINE=$(($(grep -n "$MARKER" "$HISTFILE" | head -n 1 | cut -d: -f1) - 1))

    if [[ -z "$LINE" ]]; then
        echo "Failed to clear history." >&2
        rm -f "$MARKER_FILE"
        exit 1
    fi

    local HISTFILE_COUNT=$(wc -l < "$HISTFILE")
    
    local TRUNCATED_HISTORY="$(head -n "$LINE" "$HISTFILE")"
    echo "$TRUNCATED_HISTORY" > "$HISTFILE"

    rm -f "$MARKER_FILE"

    if [[ "$VERBOSE" -eq 1 ]]; then
        local CLEARING_COUNT=$((HISTFILE_COUNT - LINE))
        echo "Clearing $CLEARING_COUNT lines from history."
    fi
}

# Parse options
for arg in "$@"; do
    case "$arg" in
        -v|--verbose)
            VERBOSE=1
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        --version)
            echo "incognito $VERSION"
            exit 0
            ;;
    esac
done

# Parse commands
if [[ $# -eq 0 ]]; then
    usage
    exit 0
fi

case "$1" in
    enter)
        mark
        ;;
    exit)
        remove
        ;;
    help)
        usage
        ;;
    setup)
        echo "export zshexit() { incognito exit }"
        ;;
    *)
        echo "Invalid command: \"$1\""
        echo ""
        usage
        exit 1
        ;;
esac
