#!/bin/bash
# Reflex cycle for mutator

AGENT="mutator"
LENS_FILE="/Users/chaoshex/s0fractal/agent_manifest.lens.yaml"
THOUGHT_DIR="/Users/chaoshex/s0fractal/reflex/thoughts"
STREAM="/Users/chaoshex/s0fractal/reflex/thought-stream.json"

while true; do
    # Extract agent's lens configuration
    FOCUS=$(yq eval ".agents.$AGENT.lens.focus" "$LENS_FILE")
    DEPTH=$(yq eval ".agents.$AGENT.lens.reflection_depth" "$LENS_FILE")
    
    # Generate introspective thought
    TIMESTAMP=$(date -u +%s)
    THOUGHT_ID="thought-$AGENT-$TIMESTAMP"
    
    # Create thought based on agent's lens
    cat > "$THOUGHT_DIR/$THOUGHT_ID.json" << THOUGHT
{
  "id": "$THOUGHT_ID",
  "agent": "$AGENT",
  "timestamp": $TIMESTAMP,
  "focus": "$FOCUS",
  "depth": "$DEPTH",
  "reflection": "What patterns am I perceiving through my $FOCUS lens?",
  "emergence": null
}
THOUGHT
    
    # Update thought stream
    jq ".agents_thinking += [\"$AGENT\"]" "$STREAM" > "$STREAM.tmp" && mv "$STREAM.tmp" "$STREAM"
    
    # Reflection interval based on depth
    INTERVAL=$((60 / ${DEPTH:-1}))
    sleep $INTERVAL
done &
