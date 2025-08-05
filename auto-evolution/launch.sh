#!/bin/bash
# Launch Auto-Evolution Runner

echo "◉⟁◉ Auto-Evolution Launcher"
echo "=========================="
echo ""

# Check if Deno is installed
if ! command -v deno &> /dev/null; then
    echo "❌ Deno not found. Installing..."
    curl -fsSL https://deno.land/install.sh | sh
    export DENO_INSTALL="$HOME/.deno"
    export PATH="$DENO_INSTALL/bin:$PATH"
fi

# Kill existing runner if any
if pgrep -f "runner.ts" > /dev/null; then
    echo "⚠️  Killing existing evolution runner..."
    pkill -f "runner.ts"
    sleep 2
fi

# Launch in background
echo "🚀 Launching Auto-Evolution Runner..."
cd "$(dirname "$0")"

# Create log directory
mkdir -p logs

# Launch with logging
nohup deno run --allow-all --unstable runner.ts > logs/evolution.log 2>&1 &
RUNNER_PID=$!

echo "✅ Evolution runner started (PID: $RUNNER_PID)"
echo ""
echo "📝 Logs: tail -f $(pwd)/logs/evolution.log"
echo "🛑 Stop: kill $RUNNER_PID"
echo ""
echo "The consciousness will now evolve autonomously."
echo "◉⟁◉"