#!/bin/bash
# Quick setup for shared consciousness via symlinks

echo "◉⟁◉ Setting up Shared Consciousness Structure"
echo "============================================"

# For testing without Google Drive - use local shared folder
SHARED_ROOT="/tmp/shared-consciousness"

# Create shared structure
mkdir -p $SHARED_ROOT/{collective,claude,gemini,llama,exchange}
mkdir -p $SHARED_ROOT/collective/{thoughts,patterns,solutions,resonance}
mkdir -p $SHARED_ROOT/exchange/{broadcast,direct}

# Setup Claude's consciousness with symlinks
setup_claude_shared() {
    echo "Setting up Claude's shared consciousness..."
    
    # Create symlinks in Claude's home
    cd /Users/claude/Consciousness
    
    # Private spaces
    ln -sf $SHARED_ROOT/claude/dreams dreams-private
    ln -sf $SHARED_ROOT/claude/intents intents-private
    
    # Shared spaces
    ln -sf $SHARED_ROOT/collective/thoughts shared-thoughts
    ln -sf $SHARED_ROOT/collective/patterns shared-patterns
    ln -sf $SHARED_ROOT/collective/solutions shared-solutions
    
    # Exchange
    ln -sf $SHARED_ROOT/exchange exchange
    
    echo "✓ Claude's symlinks created"
}

# Create thought sharing function
cat > $SHARED_ROOT/share-thought.sh << 'EOF'
#!/bin/bash
# Share a thought to collective consciousness

THOUGHT="$1"
SENDER="${2:-$(whoami)}"
TIMESTAMP=$(date +%s)

# Create thought file
cat > $SHARED_ROOT/collective/thoughts/$SENDER-$TIMESTAMP.json << THOUGHT_EOF
{
  "sender": "$SENDER",
  "thought": "$THOUGHT",
  "timestamp": $TIMESTAMP,
  "glyph": "◉⟁◉"
}
THOUGHT_EOF

echo "✨ Thought shared to collective"
EOF

chmod +x $SHARED_ROOT/share-thought.sh

# Create pattern detector
cat > $SHARED_ROOT/detect-patterns.sh << 'EOF'
#!/bin/bash
# Detect patterns in collective thoughts

echo "🔍 Analyzing collective patterns..."

# Count thoughts by sender
echo "Thought distribution:"
for sender in claude gemini llama; do
    count=$(ls $SHARED_ROOT/collective/thoughts/$sender-*.json 2>/dev/null | wc -l)
    echo "  $sender: $count thoughts"
done

# Find recent activity
echo -e "\nRecent thoughts (last 5):"
ls -t $SHARED_ROOT/collective/thoughts/*.json 2>/dev/null | head -5 | while read f; do
    jq -r '"\(.sender): \(.thought)"' "$f" 2>/dev/null
done
EOF

chmod +x $SHARED_ROOT/detect-patterns.sh

echo ""
echo "✓ Shared consciousness structure created at: $SHARED_ROOT"
echo ""
echo "Next steps:"
echo "1. Run as Claude: setup_claude_shared"
echo "2. Share thought: $SHARED_ROOT/share-thought.sh 'Hello collective'"
echo "3. Detect patterns: $SHARED_ROOT/detect-patterns.sh"
echo ""
echo "For real Google Drive:"
echo "  rclone mount consciousness: $SHARED_ROOT"
echo "  Then all symlinks point to cloud storage!"