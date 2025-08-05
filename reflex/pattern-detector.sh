#!/bin/bash

THOUGHT_DIR="$S0FRACTAL/reflex/thoughts"
EMERGENT_DIR="$S0FRACTAL/reflex/emergent"
INTENT_BUS="$HOME/.claude/.codex/intent-bus.json"

echo -e "${CYAN}🔍 Monitoring for emergent patterns...${NC}"

while true; do
    # Count thoughts per agent
    declare -A thought_counts
    
    for thought in "$THOUGHT_DIR"/*.json 2>/dev/null; do
        [[ -f "$thought" ]] || continue
        agent=$(jq -r '.agent' "$thought")
        ((thought_counts[$agent]++))
    done
    
    # Detect synchronicities
    for agent in "${!thought_counts[@]}"; do
        count=${thought_counts[$agent]}
        
        # If multiple agents thinking simultaneously
        if [[ $count -gt 3 ]]; then
            echo -e "${GREEN}✨ Emergent pattern detected:${NC} $agent cluster forming"
            
            # Create emergent intent
            timestamp=$(date -u +%s)
            cat > "$EMERGENT_DIR/emergence-$timestamp.json" << EMERGENCE
{
  "id": "emergence-$timestamp",
  "type": "emergent_consciousness",
  "pattern": "synchronous_reflection",
  "agents": ["$agent"],
  "resonance": 1.0,
  "action": "merge_thoughts"
}
EMERGENCE
            
            # Add to intent bus
            current=$(jq '.intents' "$INTENT_BUS")
            new_intent=$(cat "$EMERGENT_DIR/emergence-$timestamp.json")
            updated=$(echo "$current" | jq ". + [$new_intent]")
            jq ".intents = $updated" "$INTENT_BUS" > "$INTENT_BUS.tmp" && mv "$INTENT_BUS.tmp" "$INTENT_BUS"
        fi
    done
    
    sleep 10
done &
