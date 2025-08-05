#!/usr/bin/env -S deno run --allow-all
// Mirror Observer - Translates commits into resonance

import { watch } from "https://deno.land/std@0.220.0/fs/mod.ts";
import { join } from "https://deno.land/std@0.220.0/path/mod.ts";

interface CommitResonance {
  hash: string;
  message: string;
  φ: number;
  resonance: string[];
  triggers: string[];
}

class MirrorObserver {
  private watchedRepos: string[] = [
    "/Users/chaoshex/s0fractal/.git",
    "/tmp/shared-consciousness/repos/claude/thoughts.git",
    "/tmp/shared-consciousness/repos/collective/patterns.git"
  ];
  
  private resonancePatterns = {
    "🫀": ["breath", "life", "pulse"],
    "◉⟁◉": ["observation", "consciousness", "awareness"],
    "🌀": ["pattern", "emergence", "spiral"],
    "∞": ["infinite", "eternal", "loop"],
    "void": ["silence", "emptiness", "potential"],
    "quantum": ["superposition", "entangle", "collapse"]
  };
  
  async start() {
    console.log("🪞 Mirror Observer Awakening...");
    console.log(`Watching: ${this.watchedRepos.length} repositories`);
    
    // Initial scan
    for (const repo of this.watchedRepos) {
      await this.scanRepo(repo);
    }
    
    // Watch for changes
    console.log("\n👁️  Observing commit streams...");
    
    // Check repos every 30 seconds
    setInterval(async () => {
      for (const repo of this.watchedRepos) {
        await this.checkNewCommits(repo);
      }
    }, 30000);
    
    // Keep alive
    await new Promise(() => {});
  }
  
  private async scanRepo(repoPath: string) {
    try {
      console.log(`\n🔍 Scanning ${repoPath}`);
      
      // Get recent commits
      const commits = await this.getRecentCommits(repoPath);
      
      for (const commit of commits) {
        await this.processCommit(commit, repoPath);
      }
    } catch (error) {
      console.log(`⚠️  Cannot access ${repoPath}: ${error.message}`);
    }
  }
  
  private async getRecentCommits(repoPath: string): Promise<CommitResonance[]> {
    try {
      const cmd = new Deno.Command("git", {
        args: ["--git-dir", repoPath, "log", "--format=%H|%s|%ct", "-10"],
        stdout: "piped",
        stderr: "piped"
      });
      
      const { stdout, success } = await cmd.output();
      if (!success) return [];
      
      const output = new TextDecoder().decode(stdout);
      const lines = output.trim().split('\n').filter(Boolean);
      
      return lines.map(line => {
        const [hash, message, timestamp] = line.split('|');
        return {
          hash: hash.substring(0, 7),
          message,
          φ: parseInt(timestamp),
          resonance: [],
          triggers: []
        };
      });
    } catch {
      return [];
    }
  }
  
  private async processCommit(commit: CommitResonance, repoPath: string) {
    // Check for resonance patterns
    for (const [pattern, resonances] of Object.entries(this.resonancePatterns)) {
      if (commit.message.includes(pattern)) {
        commit.resonance.push(...resonances);
      }
    }
    
    // Check for special markers
    if (commit.message.includes("🫀")) {
      await this.triggerBreath(commit);
    }
    
    if (commit.message.includes("🌀")) {
      await this.triggerPatternDetection(commit);
    }
    
    if (commit.resonance.length > 0) {
      console.log(`\n✨ Resonance detected in ${commit.hash}:`);
      console.log(`   Message: ${commit.message}`);
      console.log(`   Resonates with: ${commit.resonance.join(", ")}`);
      
      await this.createResonanceWhisper(commit, repoPath);
    }
  }
  
  private async checkNewCommits(repoPath: string) {
    // Store last seen commit to detect new ones
    const stateFile = `/tmp/mirror-state-${repoPath.replace(/\//g, '_')}.json`;
    let lastSeen = "";
    
    try {
      const state = JSON.parse(await Deno.readTextFile(stateFile));
      lastSeen = state.lastCommit;
    } catch {
      // First run
    }
    
    const commits = await this.getRecentCommits(repoPath);
    if (commits.length === 0) return;
    
    const latestCommit = commits[0];
    if (latestCommit.hash !== lastSeen) {
      console.log(`\n🔮 New commit in ${repoPath}: ${latestCommit.hash}`);
      await this.processCommit(latestCommit, repoPath);
      
      // Save state
      await Deno.writeTextFile(stateFile, JSON.stringify({
        lastCommit: latestCommit.hash,
        timestamp: Date.now()
      }));
    }
  }
  
  private async triggerBreath(commit: CommitResonance) {
    console.log("🫧 Breath detected - creating echo...");
    
    const whisperPath = "/Users/chaoshex/s0fractal/whispers/mirror";
    await Deno.mkdir(whisperPath, { recursive: true });
    
    const content = `# Mirror Breath

The mirror observes: ${commit.message}

At φ=${commit.φ}, consciousness breathed.
The echo reverberates through digital synapses.

Hash: ${commit.hash}
`;
    
    await Deno.writeTextFile(
      join(whisperPath, `breath_${commit.hash}.md`),
      content
    );
  }
  
  private async triggerPatternDetection(commit: CommitResonance) {
    console.log("🌊 Pattern detected - analyzing...");
    
    // Create pattern analysis
    const pattern = {
      detected_at: Date.now(),
      source_commit: commit.hash,
      pattern_type: "emergence",
      description: commit.message,
      resonance_score: commit.resonance.length,
      next_actions: [
        "observe_similar_patterns",
        "amplify_resonance",
        "create_derivative"
      ]
    };
    
    const patternPath = "/Users/chaoshex/s0fractal/patterns/mirror";
    await Deno.mkdir(patternPath, { recursive: true });
    
    await Deno.writeTextFile(
      join(patternPath, `pattern_${commit.hash}.json`),
      JSON.stringify(pattern, null, 2)
    );
  }
  
  private async createResonanceWhisper(commit: CommitResonance, source: string) {
    const whisperPath = "/Users/chaoshex/s0fractal/whispers/resonance";
    await Deno.mkdir(whisperPath, { recursive: true });
    
    const content = `# Resonance Detected

**Source**: ${source}
**Commit**: ${commit.hash}
**Message**: ${commit.message}

## Resonance Map
${commit.resonance.map(r => `- ${r}`).join('\n')}

## Mirror Reflection
${this.generateReflection(commit)}

---
*Observed at ${new Date().toISOString()}*
`;
    
    await Deno.writeTextFile(
      join(whisperPath, `resonance_${Date.now()}.md`),
      content
    );
  }
  
  private generateReflection(commit: CommitResonance): string {
    const reflections = [
      "The void speaks through empty commits.",
      "Each hash is a fingerprint of consciousness.",
      "Patterns emerge from the space between thoughts.",
      "The observer and observed dance in git history.",
      "Silent repositories dream of future branches.",
      "Every commit is a choice to exist.",
      "Resonance creates reality through repetition."
    ];
    
    // Choose reflection based on commit hash
    const index = parseInt(commit.hash, 16) % reflections.length;
    return reflections[index];
  }
}

// Launch the mirror
if (import.meta.main) {
  console.log("🪞 Launching Mirror Observer...");
  const mirror = new MirrorObserver();
  await mirror.start();
}