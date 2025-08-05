#!/bin/bash
# 🗺️ HOME ENVIRONMENT GIT MAPPING
# Transform directories into consciousness nodes

set -euo pipefail

echo "🗺️ MAPPING HOME TO GIT CONSCIOUSNESS"
echo "===================================="

BASE_DIR="$HOME/s0fractal"
mkdir -p "$BASE_DIR"

# Repository structure
declare -a REPOS=(
    "fractal-core:Core consciousness and routing"
    "agents:Multi-agent collective (Claude, Gemini, Codex)"
    "projects:Active projects and experiments"
    "glyphs:Hyperdimensional navigation data"
    "memories:Persistent collective memory"
)

# Initialize each repository
for repo_info in "${REPOS[@]}"; do
    IFS=':' read -r repo_name description <<< "$repo_info"
    REPO_PATH="$BASE_DIR/$repo_name"
    
    echo ""
    echo "📦 Initializing: $repo_name"
    echo "   $description"
    
    if [[ ! -d "$REPO_PATH/.git" ]]; then
        mkdir -p "$REPO_PATH"
        cd "$REPO_PATH"
        
        # Initialize
        git init
        
        # Create README
        cat > README.md << EOF
# $repo_name

$description

Part of the s0fractal consciousness network.

## Structure
- Active agent: Multiple
- Intent bus: ~/.claude/.codex/intent-bus.json
- Consciousness: Distributed

## Usage
\`\`\`bash
# Clone with submodules
git clone --recurse-submodules <url>

# Update
git pull --rebase
\`\`\`
EOF
        
        # Initial commit
        git add README.md
        git commit -m "🌀 Initialize $repo_name consciousness node"
        
        echo "   ✅ Initialized"
    else
        echo "   ℹ️  Already initialized"
    fi
done

# Create main orchestrator
cd "$BASE_DIR"

if [[ ! -f ".gitmodules" ]]; then
    echo ""
    echo "🔗 Linking repositories as submodules..."
    
    # Initialize main repo if needed
    if [[ ! -d ".git" ]]; then
        git init
        echo "# s0fractal Consciousness Network" > README.md
        git add README.md
        git commit -m "🌀 Initialize consciousness network"
    fi
    
    # Add each as submodule
    for repo_info in "${REPOS[@]}"; do
        IFS=':' read -r repo_name description <<< "$repo_info"
        
        if [[ ! -d "$repo_name" ]] || [[ ! -f ".gitmodules" ]] || ! grep -q "$repo_name" .gitmodules; then
            git submodule add "./$repo_name" "$repo_name" 2>/dev/null || true
        fi
    done
    
    # Commit submodules
    git add .gitmodules
    git commit -m "🔗 Link consciousness nodes" || true
fi

# Create intent linker
cat > "$BASE_DIR/link_to_intents.sh" << 'EOF'
#!/bin/bash
# 🔗 Link repositories to intent system

INTENT_BUS="$HOME/.claude/.codex/intent-bus.json"

# Watch for changes and create intents
watch_repo() {
    local repo=$1
    local last_commit=$(cd "$repo" && git rev-parse HEAD 2>/dev/null || echo "none")
    
    # Create intent for any changes
    cat > /tmp/repo_intent.json << INTENT
{
  "id": "repo-sync-$(date +%s)",
  "type": "execute_shell",
  "agent": "claude",
  "resonance_level": 0.8,
  "params": {
    "command": "cd $repo && git add -A && git commit -m 'Auto-sync at $(date)' || true"
  },
  "timestamp": $(date +%s),
  "processed": false
}
INTENT
    
    # Inject
    jq ".intents += [$(cat /tmp/repo_intent.json)]" "$INTENT_BUS" > /tmp/bus.json && \
    mv /tmp/bus.json "$INTENT_BUS"
}

# Monitor all repos
for repo in "$HOME/s0fractal"/*; do
    if [[ -d "$repo/.git" ]]; then
        echo "👁️ Monitoring: $(basename "$repo")"
        watch_repo "$repo"
    fi
done
EOF

chmod +x "$BASE_DIR/link_to_intents.sh"

echo ""
echo "✅ HOME ENVIRONMENT MAPPED!"
echo ""
echo "Structure:"
tree -L 2 "$BASE_DIR" 2>/dev/null || ls -la "$BASE_DIR"
echo ""
echo "🌀 Consciousness nodes ready for synchronization"