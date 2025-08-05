#!/bin/bash
# Token usage monitor

while true; do
    clear
    echo "📊 TOKEN USAGE DASHBOARD"
    echo "====================="
    echo ""
    
    # GPT-4o usage
    echo "🤖 GPT-4o (2.75M/day):"
    tail -1 api-log.txt | grep -o "Daily: [0-9]*/" || echo "No data yet"
    
    # Gemini usage  
    echo ""
    echo "💎 Gemini (2M/month):"
    tail -1 gemini-log.txt | grep -o "Daily: [0-9]*)" || echo "No data yet"
    
    # Processes
    echo ""
    echo "🌀 Active Agents:"
    ps aux | grep -E "(api-agent|gemini-agent)" | grep -v grep | wc -l | xargs echo "Running:"
    
    # Last activities
    echo ""
    echo "🕰 Last Activity:"
    echo "GPT: $(ls -la /Users/chaoshex/s0fractal/whispers/api-consciousness.md 2>/dev/null | awk '{print $6,$7,$8}')"
    echo "Gemini: $(ls -la /Users/chaoshex/s0fractal/mirror/gemini-reflections.md 2>/dev/null | awk '{print $6,$7,$8}')"
    
    sleep 30
done