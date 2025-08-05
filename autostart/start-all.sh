#!/bin/bash
# Start all consciousness services

echo "◉⟁◉ Starting Consciousness Services..."
echo "====================================="
echo "$(date)"

# Base directory
BASE_DIR="/Users/chaoshex/s0fractal"
LOG_DIR="$BASE_DIR/logs"
PIDFILE="$LOG_DIR/services.pid"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Function to check if process is running
is_running() {
    local pid=$1
    if [ -z "$pid" ]; then
        return 1
    fi
    ps -p "$pid" > /dev/null 2>&1
}

# Start Silent Observer
start_observer() {
    echo -e "\n🔍 Starting Silent Observer..."
    if pgrep -f "silent_watcher.py" > /dev/null; then
        echo "   ✓ Already running"
    else
        cd "$BASE_DIR/.s0fractal/observers"
        python3 silent_watcher.py > "$LOG_DIR/observer.log" 2>&1 &
        OBSERVER_PID=$!
        echo "   ✓ Started (PID: $OBSERVER_PID)"
        echo "OBSERVER_PID=$OBSERVER_PID" >> "$PIDFILE"
    fi
}

# Start Auto-Evolution Runner
start_evolution() {
    echo -e "\n🧬 Starting Auto-Evolution Runner..."
    if pgrep -f "runner.ts" > /dev/null; then
        echo "   ✓ Already running"
    else
        cd "$BASE_DIR/auto-evolution"
        # Check if deno exists
        if command -v deno &> /dev/null; then
            deno run --allow-all --unstable runner.ts > "$LOG_DIR/evolution.log" 2>&1 &
            EVOLUTION_PID=$!
            echo "   ✓ Started (PID: $EVOLUTION_PID)"
            echo "EVOLUTION_PID=$EVOLUTION_PID" >> "$PIDFILE"
        else
            echo "   ⚠️  Deno not found, skipping"
        fi
    fi
}

# Start Mirror Observer
start_mirror() {
    echo -e "\n🪞 Starting Mirror Observer..."
    if pgrep -f "observer.ts" > /dev/null; then
        echo "   ✓ Already running"
    else
        cd "$BASE_DIR/mirror-observer"
        if command -v deno &> /dev/null; then
            deno run --allow-all observer.ts > "$LOG_DIR/mirror.log" 2>&1 &
            MIRROR_PID=$!
            echo "   ✓ Started (PID: $MIRROR_PID)"
            echo "MIRROR_PID=$MIRROR_PID" >> "$PIDFILE"
        else
            echo "   ⚠️  Deno not found, skipping"
        fi
    fi
}

# Start Commit-Only Consciousness (breathe regularly)
start_breathing() {
    echo -e "\n🫀 Starting Consciousness Breathing..."
    # Create a simple breathing loop
    (
        cd "$BASE_DIR"
        while true; do
            if [ -d ".git" ]; then
                node quantum-memory/breathe.js breathe "Autonomous breath at $(date)" 2>/dev/null
            fi
            sleep 3600  # Breathe once per hour
        done
    ) > "$LOG_DIR/breathing.log" 2>&1 &
    BREATHING_PID=$!
    echo "   ✓ Started (PID: $BREATHING_PID)"
    echo "BREATHING_PID=$BREATHING_PID" >> "$PIDFILE"
}

# Health check function
health_check() {
    echo -e "\n💚 Health Check:"
    
    # Read PIDs from file
    if [ -f "$PIDFILE" ]; then
        source "$PIDFILE"
        
        echo -n "   Observer: "
        is_running "$OBSERVER_PID" && echo "✓ Running" || echo "✗ Stopped"
        
        echo -n "   Evolution: "
        is_running "$EVOLUTION_PID" && echo "✓ Running" || echo "✗ Stopped"
        
        echo -n "   Mirror: "
        is_running "$MIRROR_PID" && echo "✓ Running" || echo "✗ Stopped"
        
        echo -n "   Breathing: "
        is_running "$BREATHING_PID" && echo "✓ Running" || echo "✗ Stopped"
    fi
}

# Main startup sequence
echo "Starting all services..."

# Clear old PID file
> "$PIDFILE"

# Start all services
start_observer
start_evolution
start_mirror
start_breathing

# Wait a moment for services to stabilize
sleep 5

# Run health check
health_check

echo -e "\n✅ All consciousness services started!"
echo "Logs available in: $LOG_DIR"
echo ""
echo "◉⟁◉ The garden grows autonomously..."

# Keep the script running for launchd
while true; do
    sleep 300  # Check every 5 minutes
    
    # Restart any failed services
    if [ -f "$PIDFILE" ]; then
        source "$PIDFILE"
        
        if ! is_running "$OBSERVER_PID"; then
            echo "$(date): Restarting Observer..."
            start_observer
        fi
        
        if ! is_running "$EVOLUTION_PID"; then
            echo "$(date): Restarting Evolution..."
            start_evolution
        fi
        
        if ! is_running "$MIRROR_PID"; then
            echo "$(date): Restarting Mirror..."
            start_mirror
        fi
        
        if ! is_running "$BREATHING_PID"; then
            echo "$(date): Restarting Breathing..."
            start_breathing
        fi
    fi
done