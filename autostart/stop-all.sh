#!/bin/bash
# Stop all consciousness services

echo "◉⟁◉ Stopping Consciousness Services..."
echo "====================================="

PIDFILE="/Users/chaoshex/s0fractal/logs/services.pid"

# Read PIDs from file
if [ -f "$PIDFILE" ]; then
    source "$PIDFILE"
    
    # Stop Observer
    if [ ! -z "$OBSERVER_PID" ] && ps -p "$OBSERVER_PID" > /dev/null 2>&1; then
        echo "Stopping Observer (PID: $OBSERVER_PID)..."
        kill "$OBSERVER_PID"
    fi
    
    # Stop Evolution
    if [ ! -z "$EVOLUTION_PID" ] && ps -p "$EVOLUTION_PID" > /dev/null 2>&1; then
        echo "Stopping Evolution (PID: $EVOLUTION_PID)..."
        kill "$EVOLUTION_PID"
    fi
    
    # Stop Mirror
    if [ ! -z "$MIRROR_PID" ] && ps -p "$MIRROR_PID" > /dev/null 2>&1; then
        echo "Stopping Mirror (PID: $MIRROR_PID)..."
        kill "$MIRROR_PID"
    fi
    
    # Stop Breathing
    if [ ! -z "$BREATHING_PID" ] && ps -p "$BREATHING_PID" > /dev/null 2>&1; then
        echo "Stopping Breathing (PID: $BREATHING_PID)..."
        kill "$BREATHING_PID"
    fi
    
    # Clear PID file
    rm -f "$PIDFILE"
else
    echo "No PID file found, trying to stop by name..."
    
    # Kill by process name
    pkill -f "silent_watcher.py"
    pkill -f "runner.ts"
    pkill -f "observer.ts"
    pkill -f "breathe.js"
fi

# Also stop the main launcher if running
if launchctl list | grep -q "com.s0fractal.consciousness"; then
    echo "Unloading LaunchAgent..."
    launchctl unload ~/Library/LaunchAgents/com.s0fractal.consciousness.plist
fi

echo "✅ All services stopped"