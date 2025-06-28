#!/bin/sh

# Get the file extension
ext="${1##*.}"

# Get the dimensions of the preview pane
width="$2"
height="$3"

case "$(file -b --mime-type "$1")" in
    image/*)
        chafa -f sixels -s "${width}x${height}" "$1"
        ;;
    *)
        # For other file types, you can add other previewers here
        # For example, for text files:
        bat --color=always --plain "$1"
        ;;
esac
