#!/bin/sh

# Get the file extension
ext="${1##*.}"

# Get the dimensions of the preview pane
path="$1"
width="$2"
height="$3"

case "$(file -b --mime-type "$1")" in
    # --- IMAGES ---
    image/*)
        # Use chafa for sixel image previews in a compatible terminal (like foot)
        chafa -f sixels -s "${width}x${height}" -- "$path"
        ;;

    # --- ARCHIVES ---
    application/zip|application/x-tar|application/x-gzip|application/x-bzip2|application/x-7z-compressed|application/x-rar)
        # Use atool to list contents, pipe to bat for nice formatting
        atool -l -- "$path" | bat --language=sh --color=always
        ;;

    # --- TEXT / CODE ---
    text/*|application/json|application/x-shellscript)
        # Use bat for syntax-highlighted previews of text files
        bat --color=always --plain --line-range :500 -- "$path"
        ;;

    # --- FALLBACK for other file types ---
    *)
        # Show basic file info for anything else
        file "$path"
        ;;
esac
