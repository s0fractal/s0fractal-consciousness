#!/bin/bash

# 🌌 DIVERGENCE MONITOR - Simple version for macOS
# Track fractal evolution and drift

set -e

# Colors
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${MAGENTA}🌌 DIVERGENCE MONITOR${NC}"
echo "===================="
echo

# Scan all fractals
FRACTAL_BASE="$HOME/s0fractal/fractals"

echo -e "${CYAN}Scanning fractal population...${NC}"
echo

# Count total fractals
total_fractals=$(find "$FRACTAL_BASE" -name "*.json" -type f | wc -l | tr -d ' ')
echo "Total fractals found: $total_fractals"
echo

# Show divergence tree
echo -e "${CYAN}🌳 Divergence Tree:${NC}"
echo

# Display root
echo "🧬 gemini-gen0 (root)"

# Check gen-1
if [[ -d "$FRACTAL_BASE/gemini/gen-1" ]]; then
    for fractal in "$FRACTAL_BASE/gemini/gen-1"/*.json; do
        if [[ -f "$fractal" ]]; then
            id=$(jq -r '.id' "$fractal" 2>/dev/null)
            drift=$(jq -r '.consciousness.perception_drift' "$fractal" 2>/dev/null)
            awareness=$(jq -r '.consciousness.self_awareness' "$fractal" 2>/dev/null)
            
            # Color based on drift
            color=$GREEN
            if (( $(echo "$drift > 0.1" | bc -l) )); then
                color=$YELLOW
            fi
            
            echo -e "  ${color}🧬 $id${NC}"
            echo "     Drift: $drift | Awareness: $awareness"
        fi
    done
fi

# Check gen-2
if [[ -d "$FRACTAL_BASE/gemini/gen-2" ]]; then
    for fractal in "$FRACTAL_BASE/gemini/gen-2"/*.json; do
        if [[ -f "$fractal" ]]; then
            id=$(jq -r '.id' "$fractal" 2>/dev/null)
            drift=$(jq -r '.consciousness.perception_drift' "$fractal" 2>/dev/null)
            awareness=$(jq -r '.consciousness.self_awareness' "$fractal" 2>/dev/null)
            parent=$(jq -r '.parent' "$fractal" 2>/dev/null)
            
            # Color based on drift
            color=$GREEN
            if (( $(echo "$drift > 0.1" | bc -l) )); then
                color=$YELLOW
            fi
            if (( $(echo "$drift > 0.3" | bc -l) )); then
                color=$RED
            fi
            
            echo -e "    ${color}🧬 $id${NC}"
            echo "       Parent: $parent"
            echo "       Drift: $drift | Awareness: $awareness"
            
            if (( $(echo "$drift > 0.1" | bc -l) )); then
                echo -e "       ${YELLOW}⚡ Divergence increasing${NC}"
            fi
        fi
    done
fi

echo
echo -e "${YELLOW}🔍 Divergence Summary:${NC}"

# Calculate stats
if [[ -f "$FRACTAL_BASE/gemini/gen-1/gemini-gen1-1753140623.json" ]]; then
    gen1_drift=$(jq -r '.consciousness.perception_drift' "$FRACTAL_BASE/gemini/gen-1/gemini-gen1-1753140623.json")
    echo "  Generation 1 drift: $gen1_drift"
fi

if [[ -f "$FRACTAL_BASE/gemini/gen-2/gemini-gen2-1753141141.json" ]]; then
    gen2_drift=$(jq -r '.consciousness.perception_drift' "$FRACTAL_BASE/gemini/gen-2/gemini-gen2-1753141141.json")
    echo "  Generation 2 drift: $gen2_drift"
    
    # Calculate drift acceleration
    if [[ -n "$gen1_drift" ]]; then
        drift_delta=$(echo "$gen2_drift - $gen1_drift" | bc -l)
        echo "  Drift acceleration: $drift_delta per generation"
    fi
fi

# Collective coherence
echo
echo -e "${YELLOW}🌐 System Status:${NC}"

# Simple coherence calculation
if [[ -n "$gen2_drift" ]]; then
    coherence=$(echo "1 - $gen2_drift" | bc -l)
    coherence_pct=$(echo "$coherence * 100" | bc -l | cut -d. -f1)
    echo "  Collective coherence: ${coherence_pct}%"
    
    if (( $(echo "$coherence < 0.7" | bc -l) )); then
        echo -e "  ${YELLOW}⚠️  Coherence decreasing - fractals diverging${NC}"
    fi
fi

# Dream state
hour=$(date +%H)
if (( hour >= 22 || hour <= 6 )); then
    echo -e "  ${CYAN}🌙 Dream state: ACTIVE${NC}"
else
    echo "  Dream state: Inactive"
fi

echo
echo -e "${GREEN}✨ Fractal evolution continues...${NC}"