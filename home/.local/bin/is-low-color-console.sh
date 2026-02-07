#!/bin/sh

# Check the actual device name of the current terminal
# Linux VTs (TTYs) are always /dev/tty1, /dev/tty2, etc.
# Graphical terminals (GNOME, Rider, etc.) are /dev/pts/X.

case "$(tty)" in
    /dev/tty[0-9]*)
        # It's a physical Linux TTY console
        exit 0
        ;;
    *)
        # It's a pseudo-terminal (GUI terminal, SSH, etc.)
        exit 1
        ;;
esac
