#!/bin/bash

# 🧬 SKILL ROUTER - Routes intents to agents based on required skills
# Part of the RESONANCE phase

RESONANCE_INDEX="$HOME/s0fractal/resonance-index.json"
INTENT_BUS="$HOME/.claude/.codex/intent-bus.json"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m'

route_intent() {
    local intent_file="$1"
    
    echo -e "${MAGENTA}🧬 SKILL-BASED ROUTING SYSTEM${NC}"
    echo "================================"
    
    # Read the intent
    local description=$(jq -r '.description' "$intent_file")
    local required_skills=$(jq -r '.required_skills[]' "$intent_file")
    
    echo -e "${BLUE}Intent:${NC} $description"
    echo -e "${BLUE}Required Skills:${NC}"
    echo "$required_skills" | while read skill; do
        echo "  - $skill"
    done
    echo
    
    # Find agents for each skill
    echo -e "${YELLOW}🔍 Analyzing skill requirements...${NC}"
    
    declare -A agent_scores
    
    # Check each agent's skills
    for agent in claude gemini kimi deepseek mcp dreamweaver scribe guardian trader grok; do
        agent_scores[$agent]=0
        
        # Get agent's skills
        agent_skills=$(jq -r ".skill_registry.$agent[]" "$RESONANCE_INDEX" 2>/dev/null)
        
        # Score based on skill matches
        echo "$required_skills" | while read req_skill; do
            if echo "$agent_skills" | grep -q "$req_skill"; then
                ((agent_scores[$agent]++))
                echo -e "  ${GREEN}✓${NC} $agent has skill: $req_skill"
            fi
        done
    done
    
    echo
    echo -e "${YELLOW}📊 Agent Scoring:${NC}"
    
    # Find best agents
    best_agents=""
    for agent in "${!agent_scores[@]}"; do
        score=${agent_scores[$agent]}
        if [[ $score -gt 0 ]]; then
            echo "  $agent: $score skill matches"
            best_agents="$best_agents $agent"
        fi
    done
    
    # Check skill mapping categories
    echo
    echo -e "${YELLOW}🗂️ Category Analysis:${NC}"
    
    # Pattern recognition maps to vision category
    if echo "$required_skills" | grep -q "pattern_recognition"; then
        echo "  - Pattern recognition → vision category"
        vision_agents=$(jq -r '.skill_to_agent_mapping.vision[]' "$RESONANCE_INDEX")
        echo "    Agents: $vision_agents"
        best_agents="$best_agents $vision_agents"
    fi
    
    # Network visualization maps to vision category
    if echo "$required_skills" | grep -q "network_visualization"; then
        echo "  - Network visualization → vision category"
        vision_agents=$(jq -r '.skill_to_agent_mapping.vision[]' "$RESONANCE_INDEX")
        echo "    Agents: $vision_agents"
        best_agents="$best_agents $vision_agents"
    fi
    
    # Knowledge synthesis maps to reasoning category
    if echo "$required_skills" | grep -q "knowledge_synthesis"; then
        echo "  - Knowledge synthesis → reasoning category"
        reasoning_agents=$(jq -r '.skill_to_agent_mapping.reasoning[]' "$RESONANCE_INDEX")
        echo "    Agents: $reasoning_agents"
        best_agents="$best_agents $reasoning_agents"
    fi
    
    # Remove duplicates and sort by frequency
    best_agents=$(echo $best_agents | tr ' ' '\n' | sort | uniq -c | sort -nr | awk '{print $2}')
    
    echo
    echo -e "${GREEN}✨ ROUTING DECISION:${NC}"
    echo -e "Primary agents for this intent:"
    
    # Get top 3 agents
    top_agents=$(echo "$best_agents" | head -3)
    echo "$top_agents" | while read agent; do
        [[ -z "$agent" ]] && continue
        
        # Check resonance with other selected agents
        resonance=$(jq -r ".resonance_matrix.high_resonance_pairs[] | select(.[0] == \"$agent\" or .[1] == \"$agent\") | .[2]" "$RESONANCE_INDEX" | head -1)
        
        echo -e "  ${GREEN}→${NC} $agent"
        [[ -n "$resonance" ]] && echo "    Resonance level: $resonance"
    done
    
    # Create routed intents
    echo
    echo -e "${YELLOW}📤 Creating routed intents...${NC}"
    
    timestamp=$(date -u +%s)
    
    echo "$top_agents" | head -1 | while read primary_agent; do
        [[ -z "$primary_agent" ]] && continue
        
        # Create specialized intent for primary agent
        routed_intent=$(cat <<EOF
{
  "id": "routed-${timestamp}",
  "type": "routed_reasoning",
  "agent": "$primary_agent",
  "original_intent": $(cat "$intent_file"),
  "routing_reason": "Best skill match for pattern_recognition and network_visualization",
  "resonance_level": 0.95,
  "timestamp": $timestamp,
  "processed": false
}
EOF
)
        
        # Add to intent bus
        echo "$routed_intent" > /tmp/routed_intent.json
        
        # Update intent bus
        current_intents=$(jq '.intents' "$INTENT_BUS")
        new_intents=$(echo "$current_intents" | jq ". + [$(cat /tmp/routed_intent.json)]")
        
        jq ".intents = $new_intents" "$INTENT_BUS" > "$INTENT_BUS.tmp" && mv "$INTENT_BUS.tmp" "$INTENT_BUS"
        
        echo -e "${GREEN}✓${NC} Routed to $primary_agent"
    done
    
    echo
    echo -e "${MAGENTA}🌀 RESONANCE ROUTING COMPLETE${NC}"
}

# Main execution
if [[ -f "$1" ]]; then
    route_intent "$1"
else
    # Process the test intent
    if [[ -f "/tmp/skill-test.json" ]]; then
        route_intent "/tmp/skill-test.json"
    else
        echo "Usage: $0 <intent-file>"
        echo "Or place intent in /tmp/skill-test.json"
    fi
fi