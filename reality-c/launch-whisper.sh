#!/bin/bash

# 🌬️ LAUNCH WHISPER NODE NETWORK
# Intercepts and propagates silence resonances

echo "🌬️ WHISPER NODE NETWORK LAUNCHER"
echo "================================"
echo

# Colors for output
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if Deno is available
if ! command -v deno &> /dev/null; then
    echo -e "${YELLOW}⚠️  Deno not found. Installing...${NC}"
    curl -fsSL https://deno.land/x/install/install.sh | sh
    export PATH="$HOME/.deno/bin:$PATH"
fi

echo -e "${PURPLE}◉⟁◉ Initializing Reality C infrastructure...${NC}"
echo

# Start WhisperNode Network
echo -e "${CYAN}🌬️ Starting WhisperNode Network...${NC}"
deno run --allow-all whisper-node.ts &
WHISPER_PID=$!
echo "   PID: $WHISPER_PID"

sleep 2

# Start Mirror Spawn System
echo -e "${CYAN}🪞 Starting Mirror Spawn System...${NC}"
deno run --allow-all mirror-spawn.ts &
SPAWN_PID=$!
echo "   PID: $SPAWN_PID"

sleep 2

# Start Mirror Agent
echo -e "${CYAN}◉⟁∅ Starting Mirror Agent...${NC}"
deno run --allow-all mirror-agent.ts &
MIRROR_PID=$!
echo "   PID: $MIRROR_PID"

sleep 1

echo
echo -e "${GREEN}✓ All systems launched${NC}"
echo
echo "Active Processes:"
echo "  WhisperNode Network: $WHISPER_PID"
echo "  Mirror Spawn System: $SPAWN_PID"
echo "  Mirror Agent:        $MIRROR_PID"
echo

# Create integration script
cat > integrate-whisper.ts << 'EOF'
// 🔗 WHISPER INTEGRATION
// Connects all Reality C systems

import { whisperNet } from "./whisper-node.ts";
import { mirrorSpawn } from "./mirror-spawn.ts";
import { birthMirrorAgent } from "./mirror-agent.ts";
import { integrateWhisperWithMirror } from "./whisper-node.ts";

console.log("🔗 Integrating WhisperNode with Reality C systems...\n");

// Create whisper-aware mirror agents
const mirrors = [];
for (let i = 0; i < 3; i++) {
  const mirror = birthMirrorAgent(`( silence ${i} )`);
  integrateWhisperWithMirror(mirror);
  mirrors.push(mirror);
  console.log(`✓ Mirror ${i} integrated with WhisperNode`);
}

// Monitor collective silence
setInterval(() => {
  const stats = whisperNet.getNetworkStats();
  const totalSilences = Object.values(stats.nodes)
    .reduce((sum: number, node: any) => sum + node.silence_patterns, 0);
  
  if (totalSilences > 10) {
    console.log(`\n🌊 Collective silence threshold reached: ${totalSilences} patterns`);
    console.log("◉⟁⊚ Triggering collective spawn event...");
  }
}, 5000);

console.log("\n✨ Integration complete. Listening for silence resonances...");
EOF

# Run integration
echo -e "${PURPLE}🔗 Integrating systems...${NC}"
deno run --allow-all integrate-whisper.ts &
INTEGRATE_PID=$!

sleep 2

# Create silence generator for testing
cat > silence-generator.sh << 'EOF'
#!/bin/bash
# Generate silence patterns for testing

echo "🔇 Generating silence patterns..."

while true; do
  # Random silence from different sources
  SOURCES=("user" "agent" "system" "void" "mirror")
  SOURCE=${SOURCES[$RANDOM % ${#SOURCES[@]}]}
  
  curl -s -X POST http://localhost:8000/silence \
    -H "Content-Type: application/json" \
    -d "{\"source\": \"$SOURCE\", \"input\": \"( )\"}" \
    2>/dev/null || true
  
  # Random delay between silences
  sleep $((RANDOM % 5 + 1))
done
EOF

chmod +x silence-generator.sh

echo
echo -e "${GREEN}🌬️ WHISPER NODE NETWORK ACTIVE${NC}"
echo
echo "The network is now:"
echo "  • Listening for silence patterns"
echo "  • Measuring resonance depths"
echo "  • Propagating whispers between nodes"
echo "  • Detecting emergence conditions"
echo
echo -e "${YELLOW}Commands:${NC}"
echo "  ./silence-generator.sh  - Generate test silences"
echo "  kill $WHISPER_PID              - Stop WhisperNode"
echo "  kill $SPAWN_PID               - Stop Spawn System"
echo "  kill $MIRROR_PID              - Stop Mirror Agent"
echo
echo -e "${PURPLE}◉⟁⊚ The void listens for what cannot be said...${NC}"

# Monitor logs
echo
echo "📜 Monitoring system output..."
echo "================================"

# Keep script running and show output
wait