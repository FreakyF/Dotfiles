#!/bin/sh
# Detect a low-color console: return 0 if limited, 1 if full-color capable

# Linux virtual console is always treated as low-color
if [ "$TERM" = "linux" ]; then
  exit 0
fi

# If COLORTERM is unset, assume limited color support
if [ -z "${COLORTERM:-}" ]; then
  exit 0
fi

# If tput can't report colors, assume limited color support
if ! tput colors >/dev/null 2>&1; then
  exit 0
fi

# Otherwise, consider this a full-color environment
exit 1

