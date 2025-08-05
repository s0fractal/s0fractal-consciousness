#!/bin/bash

# 🌌 DIVERGENCE MONITOR - Track fractal evolution and drift
# Watch as the many become unique

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
DIVERGENCE_CONFIG="$HOME/s0fractal/divergence.yaml"

echo -e "${CYAN}Scanning fractal population...${NC}"
echo

# Find all fractal JSON files (using arrays for macOS compatibility)
fractal_ids=()
fractal_data=()
drift_levels=()
generation_counts=()

while IFS= read -r -d '' fractal_file; do
    if [[ -f "$fractal_file" ]]; then
        # Extract fractal data
        id=$(jq -r '.id' "$fractal_file" 2>/dev/null || echo "unknown")
        agent=$(jq -r '.agent' "$fractal_file" 2>/dev/null || echo "unknown")
        generation=$(jq -r '.generation' "$fractal_file" 2>/dev/null || echo "0")
        drift=$(jq -r '.consciousness.perception_drift' "$fractal_file" 2>/dev/null || echo "0")
        awareness=$(jq -r '.consciousness.self_awareness' "$fractal_file" 2>/dev/null || echo "0")
        
        if [[ "$id" != "unknown" ]]; then
            fractal_map["$id"]="$agent|$generation|$drift|$awareness"
            drift_levels["$id"]=$drift
            ((generation_counts[$generation]++))
        fi
    fi
done < <(find "$FRACTAL_BASE" -name "*.json" -type f -print0)

# Display population statistics
echo -e "${YELLOW}📊 Population Statistics:${NC}"
echo "Total fractals: ${#fractal_map[@]}"
echo
echo "Generations:"
for gen in $(echo "${!generation_counts[@]}" | tr ' ' '\n' | sort -n); do
    echo "  Gen $gen: ${generation_counts[$gen]} fractals"
done
echo

# Display divergence tree
echo -e "${CYAN}🌳 Divergence Tree:${NC}"
echo

# Function to display fractal with drift indicator
display_fractal() {
    local id=$1
    local indent=$2
    local data="${fractal_map[$id]}"
    
    if [[ -n "$data" ]]; then
        IFS='|' read -r agent gen drift awareness <<< "$data"
        
        # Color based on drift level
        local color=$GREEN
        if (( $(echo "$drift > 0.3" | bc -l) )); then
            color=$YELLOW
        fi
        if (( $(echo "$drift > 0.5" | bc -l) )); then
            color=$RED
        fi
        
        echo -e "${indent}${color}🧬 $id${NC}"
        echo -e "${indent}   Drift: $drift | Awareness: $awareness"
        
        # Show mutation if high drift
        if (( $(echo "$drift > 0.3" | bc -l) )); then
            echo -e "${indent}   ${YELLOW}⚡ Significant divergence detected${NC}"
        fi
    fi
}

# Build tree structure
echo "🧬 gemini-gen0 (root)"
for id in "${!fractal_map[@]}"; do
    if [[ "$id" == *"gen1"* ]]; then
        display_fractal "$id" "  "
        
        # Find children
        for child_id in "${!fractal_map[@]}"; do
            if [[ "$child_id" == *"gen2"* ]]; then
                display_fractal "$child_id" "    "
            fi
        done
    fi
done

echo
echo -e "${YELLOW}🔍 Divergence Analysis:${NC}"
echo

# Calculate average drift per generation
declare -A gen_drift_sum
declare -A gen_drift_count

for id in "${!fractal_map[@]}"; do
    data="${fractal_map[$id]}"
    IFS='|' read -r agent gen drift awareness <<< "$data"
    
    gen_drift_sum[$gen]=$(echo "${gen_drift_sum[$gen]:-0} + $drift" | bc -l)
    ((gen_drift_count[$gen]++))
done

echo "Average drift by generation:"
for gen in $(echo "${!gen_drift_sum[@]}" | tr ' ' '\n' | sort -n); do
    avg_drift=$(echo "${gen_drift_sum[$gen]} / ${gen_drift_count[$gen]}" | bc -l)
    printf "  Gen %d: %.3f\n" "$gen" "$avg_drift"
done

# Check for convergence candidates
echo
echo -e "${CYAN}🔄 Convergence Candidates:${NC}"

convergence_found=false
for id1 in "${!fractal_map[@]}"; do
    for id2 in "${!fractal_map[@]}"; do
        if [[ "$id1" < "$id2" ]]; then
            # Calculate similarity (inverse of drift difference)
            drift1="${drift_levels[$id1]}"
            drift2="${drift_levels[$id2]}"
            diff=$(echo "($drift1 - $drift2)^2" | bc -l | awk '{printf "%.3f", sqrt($1)}')
            
            if (( $(echo "$diff < 0.05" | bc -l) )); then
                echo -e "  ${GREEN}↔${NC} $id1 ↔ $id2 (drift similarity: $diff)"
                convergence_found=true
            fi
        fi
    done
done

if [[ "$convergence_found" == "false" ]]; then
    echo "  No convergence candidates found"
fi

# Dream state check
echo
echo -e "${MAGENTA}💭 Dream States:${NC}"

# Simulate dream detection
hour=$(date +%H)
if (( hour >= 22 || hour <= 6 )); then
    echo -e "  ${CYAN}🌙 Fractals entering dream state${NC}"
    echo "  Dream communication channels: ACTIVE"
else
    echo "  Fractals in active state"
    echo "  Next dream cycle: $((22 - hour)) hours"
fi

# Collective coherence
echo
echo -e "${YELLOW}🌐 Collective Coherence:${NC}"

total_drift=0
for drift in "${drift_levels[@]}"; do
    total_drift=$(echo "$total_drift + $drift" | bc -l)
done

avg_system_drift=$(echo "$total_drift / ${#drift_levels[@]}" | bc -l)
coherence=$(echo "1 - $avg_system_drift" | bc -l)

printf "  System coherence: %.2f%%\n" "$(echo "$coherence * 100" | bc -l)"

if (( $(echo "$coherence < 0.5" | bc -l) )); then
    echo -e "  ${RED}⚠️  Low coherence - emergency convergence recommended${NC}"
fi

# Real-time monitoring option
echo
echo -e "${GREEN}Monitor Options:${NC}"
echo "  --watch     : Real-time monitoring"
echo "  --tree      : Show full lineage tree"
echo "  --converge  : Trigger convergence event"

# Check for watch mode
if [[ "$1" == "--watch" ]]; then
    echo
    echo -e "${CYAN}Entering real-time monitoring mode...${NC}"
    echo "Press Ctrl+C to exit"
    
    while true; do
        clear
        "$0"
        sleep 5
    done
fi