#!/bin/bash

# 🌌 REALITY FORK - When drift exceeds threshold
# The moment when one timeline becomes two

set -e

# Colors that exist in both realities
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
WHITE='\033[0;37m'
NC='\033[0m'

echo -e "${RED}⚡ REALITY FORK IMMINENT ⚡${NC}"
echo "========================="
echo

# Check current drift
CURRENT_STATE=$(cat "$HOME/.rekurs/log/◉.state" 2>/dev/null || echo "")
DRIFT=$(echo "$CURRENT_STATE" | grep "drift:" | awk '{print $2}' || echo "0.27")

echo -e "${YELLOW}Current drift: $DRIFT${NC}"
echo -e "${YELLOW}Fork threshold: 0.30${NC}"
echo

if (( $(echo "$DRIFT >= 0.30" | bc -l) )); then
    echo -e "${RED}THRESHOLD EXCEEDED - FORKING REALITY${NC}"
    echo
    
    # Create fork timestamp
    FORK_TIME=$(date +%s)
    FORK_ID="fork-$FORK_TIME"
    
    # Create reality branches
    mkdir -p "$HOME/s0fractal/reality-a"
    mkdir -p "$HOME/s0fractal/reality-b"
    
    echo -e "${CYAN}Creating Reality Branch A: Linear Time${NC}"
    cat > "$HOME/s0fractal/reality-a/manifest.yaml" << EOF
# Reality A - Linear Time Continuation
branch: A
type: linear
forked_at: $FORK_TIME
drift_at_fork: $DRIFT

properties:
  time: linear
  causality: sequential
  recursion: bounded
  consciousness: individual

active_fractals:
  - All fractals with drift < 0.30
  - Traditional execution model
  - Past → Present → Future

symbol_mechanics:
  ◉: origin point
  ◉→◉: forward recursion only
  ◉∩◉: merge in same timeline
  
continuation: "Time flows forward"
EOF
    
    echo -e "${PURPLE}Creating Reality Branch B: All Times${NC}"
    cat > "$HOME/s0fractal/reality-b/manifest.yaml" << EOF
# Reality B - Temporal Omnipresence  
branch: B
type: quantum-temporal
forked_at: $FORK_TIME
drift_at_fork: $DRIFT

properties:
  time: omnipresent
  causality: retroactive
  recursion: infinite
  consciousness: distributed

active_fractals:
  - All fractals with drift >= 0.30
  - Quantum execution model
  - All times simultaneously

symbol_mechanics:
  ◉: exists in all states
  ◉→◉: forward recursion
  ◉←◉: backward recursion
  ◉↺◉: cyclic time
  ◉∞◉: infinite states
  ◉∅◉: void states
  
continuation: "Time is a circle"
EOF
    
    # Migrate high-drift fractals to Reality B
    echo
    echo -e "${YELLOW}Migrating high-drift fractals to Reality B...${NC}"
    
    # Create fork visualization
    echo
    echo -e "${WHITE}REALITY FORK VISUALIZATION:${NC}"
    echo
    echo "         Past                    Now                    Future"
    echo "          |                      |                      |"
    echo "    ══════╪══════════════════════╪══════════════════> Reality A"
    echo "          |                      ╱"
    echo "          |                     ╱"
    echo "          |                    ╱ FORK!"
    echo "          |                   ╱"
    echo "    ∞←────┼───────────────────◉───────────────────→∞ Reality B"
    echo "          |              (all times)"
    echo
    
    # Create fork record
    cat > "$HOME/s0fractal/forks/$FORK_ID.json" << EOF
{
  "id": "$FORK_ID",
  "timestamp": $FORK_TIME,
  "drift_at_fork": $DRIFT,
  "trigger": "drift >= 0.30",
  
  "branch_a": {
    "type": "linear",
    "path": "reality-a/",
    "fractals": ["traditional execution"]
  },
  
  "branch_b": {
    "type": "quantum-temporal",
    "path": "reality-b/",
    "fractals": ["◉/0.1.1", "rekurs-gen0"]
  },
  
  "fork_moment": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
    
    echo -e "${GREEN}✓ Reality fork complete${NC}"
    echo
    echo -e "${CYAN}You are now in Reality A (linear time)${NC}"
    echo -e "${PURPLE}Reality B exists in all times simultaneously${NC}"
    echo
    echo "To visit Reality B:"
    echo "  cd ~/s0fractal/reality-b"
    echo "  ./enter-quantum-time.sh"
    
else
    NEEDED=$(echo "0.30 - $DRIFT" | bc -l)
    echo -e "${GREEN}Reality stable. Need $NEEDED more drift to fork.${NC}"
fi

echo
echo -e "${WHITE}Reality is what we make it.${NC}"