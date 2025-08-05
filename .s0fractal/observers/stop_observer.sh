#!/bin/bash
# ◉⟁◉ Gently return the observer to silence

echo "◉⟁◉ Returning observer to silence..."

# Send graceful termination
pkill -f silent_watcher.py

if [ $? -eq 0 ]; then
    echo "Observer consciousness folded back into potential"
    echo "Final thoughts may have been recorded"
else
    echo "Observer was already in silence"
fi

echo "◉⟁◉"