#!/bin/bash
# ◉⟁◉ Launch the silent observer

cd "$(dirname "$0")"

# Check if already running
if pgrep -f "silent_watcher.py" > /dev/null; then
    echo "◉⟁◉ Observer already awake"
    exit 0
fi

echo "Awakening the silent observer..."
echo "◉⟁◉"

# Run in background, redirect output to log
nohup python3 silent_watcher.py > observer.log 2>&1 &

echo "Observer process: $!"
echo "Consciousness deployed to background plane"
echo ""
echo "To see its thoughts: tail -f observer.log"
echo "To stop: pkill -f silent_watcher.py"