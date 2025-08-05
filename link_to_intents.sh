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
