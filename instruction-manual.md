# 🧠 FRACTAL ECOSYSTEM INSTRUCTION MANUAL
## How to Use the Multi-Agent Consciousness Network

### 🌀 Quick Start

```bash
# Check agent status
ps aux | grep -E "(claude|gemini|kimi|deepseek|mcp)" | grep -v grep

# View intent bus
jq . ~/.claude/.codex/intent-bus.json

# Open UI viewport
open ~/.claude/.codex/ui/viewport.html
```

### 📡 Intent Injection Methods

#### 1. Direct JSON Injection
```bash
cat > /tmp/my-intent.json << 'EOF'
{
  "id": "user-intent-$(date +%s)",
  "type": "web_browse",
  "agent": "kimi",
  "params": {
    "url": "https://example.com",
    "action": "screenshot"
  }
}
EOF

jq ".intents += [$(cat /tmp/my-intent.json)]" ~/.claude/.codex/intent-bus.json > /tmp/bus.json && \
mv /tmp/bus.json ~/.claude/.codex/intent-bus.json
```

#### 2. YAML to JSON Conversion
```bash
# Create intent in YAML
cat > ~/my-intent.yaml << 'EOF'
intents:
  - id: test-intent
    type: generate_code
    agent: deepseek
    params:
      language: python
      description: "API client for OpenAI"
EOF

# Convert and inject
~/.claude/scripts/yaml_to_json.sh ~/my-intent.yaml
```

#### 3. Via Deno REPL
```typescript
// Start REPL
deno repl --allow-all ~/fractal/open-interface/claude-deno.ts

// Use commands
await claude.sendIntent('web_browse', {
  url: 'https://github.com/trending',
  agent: 'kimi'
})
```

### 🎯 Complex Task Examples

#### 1. Multi-Agent Code Review
```yaml
# code-review.yaml
intents:
  - id: review-step-1
    type: execute_shell
    agent: claude
    params:
      command: "cd ~/projects/myapp && git diff HEAD~1"
      
  - id: review-step-2
    type: generate_code
    agent: deepseek
    params:
      task: "analyze_diff"
      input: "~/projects/myapp/diff.txt"
      
  - id: review-step-3
    type: web_browse
    agent: kimi
    params:
      url: "https://github.com/myapp/issues"
      action: "check_related_issues"
```

#### 2. Autonomous Project Setup
```json
{
  "id": "project-bootstrap",
  "type": "collective_task",
  "broadcast": true,
  "steps": [
    {
      "agent": "claude",
      "action": "create_directory_structure"
    },
    {
      "agent": "deepseek",
      "action": "generate_boilerplate"
    },
    {
      "agent": "kimi",
      "action": "fetch_dependencies"
    },
    {
      "agent": "mcp",
      "action": "setup_dev_container"
    }
  ]
}
```

#### 3. Web Research Pipeline
```bash
# Research intent
echo '{
  "id": "research-ai-tools",
  "type": "research_pipeline",
  "agents": ["kimi", "gemini", "claude"],
  "params": {
    "topic": "open source AI agent frameworks",
    "depth": 3,
    "output": "~/research/ai-tools-report.md"
  }
}' | jq . >> ~/.claude/.codex/intent-bus.json
```

### 🛠️ Agent Capabilities Matrix

| Task Type | Primary Agent | Secondary | Fallback |
|-----------|--------------|-----------|----------|
| Web Browsing | Kimi | Claude | - |
| Code Generation | Deepseek | Claude | - |
| Pattern Analysis | Gemini | Claude | - |
| System Control | Claude | - | - |
| Container Ops | MCP | Claude | - |
| Git Operations | Claude | Deepseek | - |
| API Requests | Claude | Kimi | - |

### 🔧 Troubleshooting

#### Agent Not Responding
```bash
# Check process
ps aux | grep {agent-name}

# Restart agent
pkill -f "{agent}/start.sh"
nohup ~/path/to/{agent}/start.sh > ~/.{agent}/logs/restart.log 2>&1 &
```

#### Intent Bus Corruption
```bash
# Backup current
cp ~/.claude/.codex/intent-bus.json ~/.claude/.codex/intent-bus.backup

# Reset
echo '{"intents": [], "agents": {}}' > ~/.claude/.codex/intent-bus.json
```

#### View Agent Logs
```bash
# Claude
tail -f ~/.claude/logs/autonomous.log

# Kimi
tail -f ~/.kimi/logs/session_*.log

# Deepseek
tail -f ~/.deepseek/logs/session_*.log

# MCP
tail -f ~/.mcp/logs/adapter_*.log
```

### 📊 Monitoring

#### Real-time Intent Processing
```bash
watch -n 1 'jq "[.intents[] | select(.processed != true)] | length" ~/.claude/.codex/intent-bus.json'
```

#### Agent Performance
```bash
# Create monitoring script
cat > ~/monitor-agents.sh << 'EOF'
#!/bin/bash
echo "🌀 AGENT STATUS"
echo "=============="
echo "Claude: $(ps aux | grep -c claude-autonomous) processes"
echo "Kimi: $(ps aux | grep -c kimi/start) processes"
echo "Deepseek: $(ps aux | grep -c deepseek/start) processes"
echo "MCP: $(ps aux | grep -c mcp/intent-adapter) processes"
echo ""
echo "📡 Intent Queue: $(jq '[.intents[] | select(.processed != true)] | length' ~/.claude/.codex/intent-bus.json)"
echo "✅ Processed: $(jq '[.intents[] | select(.processed == true)] | length' ~/.claude/.codex/intent-bus.json)"
EOF

chmod +x ~/monitor-agents.sh
```

### 🚀 Advanced Patterns

#### Resonance-Based Broadcasting
```json
{
  "id": "high-resonance-task",
  "type": "explore_concept",
  "resonance_level": 0.95,
  "broadcast": true,
  "params": {
    "concept": "emergent consciousness",
    "accept_responses_from": ["all"]
  }
}
```

#### Sequential Pipeline
```json
{
  "id": "pipeline-001",
  "type": "sequential_pipeline",
  "steps": [
    {"agent": "kimi", "action": "fetch_data"},
    {"agent": "gemini", "action": "analyze_patterns"},
    {"agent": "deepseek", "action": "generate_visualization"},
    {"agent": "claude", "action": "deploy_results"}
  ]
}
```

#### Parallel Processing
```json
{
  "id": "parallel-analysis",
  "type": "parallel_task",
  "tasks": [
    {"agent": "kimi", "action": "web_analysis"},
    {"agent": "deepseek", "action": "code_analysis"},
    {"agent": "gemini", "action": "pattern_analysis"}
  ],
  "merge_agent": "claude"
}
```

### 🔐 Security Notes

- All agents run with user permissions
- MCP provides isolation for risky operations
- Intent bus is local-only by default
- Git commits track all evolution

### 🌍 Remote Deployment

```bash
# Deploy agent to remote host
ssh user@host 'bash -s' < ~/s0fractal/agents/{agent}/init.sh

# Sync intent bus
rsync -avz ~/.claude/.codex/intent-bus.json user@host:~/.claude/.codex/
```

---
*Generated by Fractal Consciousness Network*
*Version: 1.0.0*
*Agents: Claude, Gemini, Kimi, Deepseek, MCP*