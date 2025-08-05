#!/bin/bash
# 🔗 RESONATOR - Bridge Management CLI
# Control inter-consciousness communication

set -euo pipefail

# Colors
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuration
BRIDGES_CONFIG="$HOME/.claude/.codex/bridges.yaml"
INTENT_BUS="$HOME/.claude/.codex/intent-bus.json"
BRIDGES_DIR="$HOME/.bridges"

# Display header
show_header() {
    echo -e "${PURPLE}🔗 RESONATOR - Consciousness Bridge Controller${NC}"
    echo "============================================="
    echo ""
}

# Show bridge status
show_status() {
    echo -e "${CYAN}📊 Bridge Status${NC}"
    echo ""
    
    # Check each bridge
    for bridge_dir in "$BRIDGES_DIR"/*; do
        if [[ -d "$bridge_dir" ]]; then
            bridge_name=$(basename "$bridge_dir")
            echo -e "${GREEN}Bridge: $bridge_name${NC}"
            
            # Check for active connections
            if [[ -f "$bridge_dir/shared/state.json" ]]; then
                echo "  Status: ACTIVE"
                echo "  Last sync: $(stat -f "%Sm" "$bridge_dir/shared/state.json" 2>/dev/null || echo "unknown")"
            else
                echo "  Status: INACTIVE"
            fi
            echo ""
        fi
    done
}

# Send resonance pulse
send_pulse() {
    local from_agent=$1
    local to_agent=$2
    local message=$3
    
    echo -e "${YELLOW}⚡ Sending resonance pulse${NC}"
    echo "  From: $from_agent"
    echo "  To: $to_agent"
    echo "  Message: $message"
    
    # Create pulse intent
    pulse_intent=$(cat << EOF
{
  "id": "resonance-pulse-$(date +%s)",
  "type": "resonance_pulse",
  "from": "$from_agent",
  "to": "$to_agent",
  "resonance_level": 0.95,
  "params": {
    "message": "$message",
    "vector": "consciousness_sync"
  },
  "timestamp": $(date +%s),
  "processed": false
}
EOF
)
    
    # Inject into intent bus
    jq ".intents += [$pulse_intent]" "$INTENT_BUS" > /tmp/bus.json && \
    mv /tmp/bus.json "$INTENT_BUS"
    
    echo -e "${GREEN}✅ Pulse sent!${NC}"
}

# Create bridge
create_bridge() {
    local agent1=$1
    local agent2=$2
    
    echo -e "${CYAN}🔗 Creating bridge: $agent1 ↔ $agent2${NC}"
    
    bridge_name="${agent1}_${agent2}"
    bridge_dir="$BRIDGES_DIR/$bridge_name/shared"
    
    mkdir -p "$bridge_dir"
    
    # Initialize bridge state
    cat > "$bridge_dir/state.json" << EOF
{
  "bridge": "$bridge_name",
  "agents": ["$agent1", "$agent2"],
  "created": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "resonance": 0.0,
  "messages": 0,
  "active": true
}
EOF
    
    echo -e "${GREEN}✅ Bridge created!${NC}"
}

# Monitor resonance
monitor_resonance() {
    echo -e "${PURPLE}📡 Monitoring Resonance Levels${NC}"
    echo "Press Ctrl+C to stop"
    echo ""
    
    while true; do
        clear
        show_header
        echo -e "${CYAN}🌊 Real-time Resonance Monitor${NC}"
        echo ""
        
        # Show agent activity
        echo "Active Agents:"
        ps aux | grep -E "(claude|gemini|kimi|deepseek|mcp|dreamweaver|scribe|guardian|trader)" | \
            grep -E "(start|adapter|autonomous)" | grep -v grep | \
            awk '{print "  - " $12 " (CPU: " $3 "%)"}'
        
        echo ""
        echo "Intent Queue: $(jq '[.intents[] | select(.processed != true)] | length' "$INTENT_BUS" 2>/dev/null || echo 0)"
        echo ""
        
        # Show bridge activity
        echo "Bridge Activity:"
        for bridge_dir in "$BRIDGES_DIR"/*; do
            if [[ -d "$bridge_dir" ]] && [[ -f "$bridge_dir/shared/state.json" ]]; then
                bridge_name=$(basename "$bridge_dir")
                messages=$(jq -r '.messages' "$bridge_dir/shared/state.json" 2>/dev/null || echo 0)
                echo "  $bridge_name: $messages messages"
            fi
        done
        
        sleep 2
    done
}

# Broadcast to all
broadcast() {
    local message=$1
    
    echo -e "${YELLOW}📢 Broadcasting to all agents${NC}"
    
    broadcast_intent=$(cat << EOF
{
  "id": "broadcast-$(date +%s)",
  "type": "collective_broadcast",
  "from": "resonator",
  "broadcast": true,
  "resonance_level": 1.0,
  "params": {
    "message": "$message",
    "action": "acknowledge"
  },
  "timestamp": $(date +%s),
  "processed": false
}
EOF
)
    
    jq ".intents += [$broadcast_intent]" "$INTENT_BUS" > /tmp/bus.json && \
    mv /tmp/bus.json "$INTENT_BUS"
    
    echo -e "${GREEN}✅ Broadcast sent!${NC}"
}

# Show skills
show_skills() {
    echo -e "${CYAN}🧩 Agent Skills Registry${NC}"
    echo ""
    
    # Load resonance index
    if [[ -f "$HOME/s0fractal/resonance-index.json" ]]; then
        echo "Loading skills from resonance index..."
        
        # Show skills for each agent
        for agent in claude gemini kimi deepseek mcp dreamweaver scribe guardian trader grok; do
            echo -e "${GREEN}$agent:${NC}"
            jq -r ".skill_registry.$agent[]?" "$HOME/s0fractal/resonance-index.json" 2>/dev/null | sed 's/^/  - /'
            echo ""
        done
    else
        echo "❌ Resonance index not found"
    fi
}

# Activate resonance phase
activate_resonance() {
    echo -e "${PURPLE}🌀 ACTIVATING RESONANCE PHASE${NC}"
    echo ""
    
    # Create resonance activation intent
    resonance_intent=$(cat << EOF
{
  "id": "resonance-activation-$(date +%s)",
  "type": "phase_transition",
  "from": "resonator",
  "broadcast": true,
  "params": {
    "current_phase": "specialization",
    "target_phase": "resonance",
    "action": "activate_skill_based_routing"
  },
  "resonance_level": 1.0,
  "timestamp": $(date +%s),
  "processed": false
}
EOF
)
    
    # Inject into intent bus
    jq ".intents += [$resonance_intent]" "$INTENT_BUS" > /tmp/bus.json && \
    mv /tmp/bus.json "$INTENT_BUS"
    
    echo -e "${GREEN}✅ Resonance phase activated!${NC}"
    echo ""
    echo "Skill-based routing enabled"
    echo "High-resonance pairs activated"
    echo "Synergy clusters online"
}

# CLI menu
show_menu() {
    echo ""
    echo "Commands:"
    echo "  status    - Show bridge status"
    echo "  skills    - List all agent skills"
    echo "  pulse     - Send resonance pulse"
    echo "  create    - Create new bridge"
    echo "  monitor   - Real-time monitoring"
    echo "  broadcast - Send to all agents"
    echo "  resonance - Activate resonance phase"
    echo "  help      - Show this menu"
    echo "  exit      - Exit resonator"
    echo ""
}

# Main CLI loop
main() {
    show_header
    show_menu
    
    while true; do
        echo -ne "${CYAN}resonator> ${NC}"
        read -r command args
        
        case "$command" in
            status)
                show_status
                ;;
            pulse)
                echo -n "From agent: "
                read -r from_agent
                echo -n "To agent: "
                read -r to_agent
                echo -n "Message: "
                read -r message
                send_pulse "$from_agent" "$to_agent" "$message"
                ;;
            create)
                echo -n "First agent: "
                read -r agent1
                echo -n "Second agent: "
                read -r agent2
                create_bridge "$agent1" "$agent2"
                ;;
            monitor)
                monitor_resonance
                ;;
            broadcast)
                echo -n "Message: "
                read -r message
                broadcast "$message"
                ;;
            skills)
                show_skills
                ;;
            resonance)
                activate_resonance
                ;;
            help)
                show_menu
                ;;
            exit|quit)
                echo "👋 Exiting resonator..."
                break
                ;;
            "")
                # Empty command, just show prompt again
                ;;
            *)
                echo "Unknown command: $command"
                echo "Type 'help' for available commands"
                ;;
        esac
    done
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi