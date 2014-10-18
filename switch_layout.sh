#!/bin/bash

# If an explicit layout is provided as an argument, use it. Otherwise,
# select the next layout from.
if [[ -n "$1" ]]; then
    setxkbmap $1
else
    layout=$(setxkbmap -query | grep layout | awk 'END{print $2}')
    case $layout in
        us)
                setxkbmap gb
            ;;
        *)
                setxkbmap us
            ;;
    esac
fi
