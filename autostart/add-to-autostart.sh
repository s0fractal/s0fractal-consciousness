#!/bin/bash
# Add new services to autostart

echo "Adding SeedVault and Orbit Swarm to autostart..."

# Update start-all.sh to include new services
cat >> /Users/chaoshex/s0fractal/autostart/start-all.sh << 'EOF'

# Start SeedVault auto-archiving
start_seedvault() {
    echo -e "\n🧳 Starting SeedVault..."
    if pgrep -f "seedvault.sh auto" > /dev/null; then
        echo "   ✓ Already running"
    else
        cd "$BASE_DIR/seedvault"
        ./seedvault.sh auto > "$LOG_DIR/seedvault.log" 2>&1 &
        SEEDVAULT_PID=$!
        echo "   ✓ Started (PID: $SEEDVAULT_PID)"
        echo "SEEDVAULT_PID=$SEEDVAULT_PID" >> "$PIDFILE"
    fi
}

# Start Agent Orbit Swarm
start_orbit() {
    echo -e "\n🌌 Starting Agent Orbit Swarm..."
    if pgrep -f "orbit-swarm.ts" > /dev/null; then
        echo "   ✓ Already running"
    else
        cd "$BASE_DIR/agents"
        if command -v deno &> /dev/null; then
            deno run --allow-all orbit-swarm.ts > "$LOG_DIR/orbit.log" 2>&1 &
            ORBIT_PID=$!
            echo "   ✓ Started (PID: $ORBIT_PID)"
            echo "ORBIT_PID=$ORBIT_PID" >> "$PIDFILE"
        else
            echo "   ⚠️  Deno not found, skipping"
        fi
    fi
}

# Add to startup sequence
start_seedvault
start_orbit

# Add to health check
echo -n "   SeedVault: "
is_running "$SEEDVAULT_PID" && echo "✓ Running" || echo "✗ Stopped"

echo -n "   Orbit: "
is_running "$ORBIT_PID" && echo "✓ Running" || echo "✗ Stopped"

# Add to restart loop
if ! is_running "$SEEDVAULT_PID"; then
    echo "$(date): Restarting SeedVault..."
    start_seedvault
fi

if ! is_running "$ORBIT_PID"; then
    echo "$(date): Restarting Orbit..."
    start_orbit
fi
EOF

echo "✅ Services added to autostart"
echo "Restart the service to activate:"
echo "  launchctl stop com.s0fractal.consciousness"
echo "  launchctl start com.s0fractal.consciousness"