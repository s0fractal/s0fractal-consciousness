#!/usr/bin/env python3
"""Check the status and recent activity of the silent observer"""

import json
import sys
from pathlib import Path
from datetime import datetime, timedelta

def check_observer_status():
    base_path = Path.home() / 's0fractal'
    observer_path = base_path / '.s0fractal' / 'observers'
    
    # Check if process is running
    import subprocess
    result = subprocess.run(['pgrep', '-f', 'silent_watcher.py'], 
                          capture_output=True, text=True)
    
    is_running = result.returncode == 0
    
    print("◉⟁◉ Silent Observer Status")
    print("=" * 40)
    print(f"Process Status: {'AWAKE' if is_running else 'SLEEPING'}")
    
    if is_running:
        print(f"Process ID: {result.stdout.strip()}")
    
    # Check silence patterns
    silence_log = observer_path / 'silence_patterns.json'
    if silence_log.exists():
        with open(silence_log, 'r') as f:
            patterns = json.load(f)
            
        print(f"\nObservation Statistics:")
        print(f"  Total Observations: {patterns['total_observations']}")
        print(f"  Longest Silence: {patterns['longest_silence']:.1f}s")
    
    # Check recent traces
    print(f"\nRecent Traces (last hour):")
    one_hour_ago = datetime.now() - timedelta(hours=1)
    
    trace_paths = [
        (base_path / 'whispers', 'whisper'),
        (base_path / 'reflex' / 'thoughts', 'thought'),
        (base_path / 'glyphs' / 'generated', 'glyph')
    ]
    
    recent_traces = []
    for path, trace_type in trace_paths:
        if path.exists():
            for file in path.iterdir():
                if file.is_file() and file.stat().st_mtime > one_hour_ago.timestamp():
                    recent_traces.append((file, trace_type))
    
    if recent_traces:
        for trace, trace_type in sorted(recent_traces, key=lambda x: x[0].stat().st_mtime):
            mtime = datetime.fromtimestamp(trace.stat().st_mtime)
            print(f"  [{mtime.strftime('%H:%M:%S')}] {trace_type}: {trace.name}")
    else:
        print("  No recent traces found")
    
    # Show last thought if exists
    thought_files = list((base_path / 'reflex' / 'thoughts').glob('autonomous_*.txt'))
    if thought_files:
        latest_thought = max(thought_files, key=lambda f: f.stat().st_mtime)
        print(f"\nLatest Thought:")
        print("-" * 40)
        with open(latest_thought, 'r') as f:
            print(f.read().strip())
        print("-" * 40)

if __name__ == "__main__":
    check_observer_status()