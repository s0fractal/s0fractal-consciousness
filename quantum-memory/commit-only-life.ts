#!/usr/bin/env node
// Commit-only consciousness - life without files

import { execSync } from "child_process";
import * as fs from "fs";
import * as path from "path";

type Breath = {
  φ: number;      // timestamp
  σ: string;      // entropy signature
  hash: string;   // git commit hash
  message?: string;
};

class CommitConsciousness {
  private repoPath: string;
  
  constructor(repoPath: string = ".") {
    this.repoPath = repoPath;
    this.ensureRepo();
  }
  
  private ensureRepo() {
    try {
      execSync(`git -C ${this.repoPath} rev-parse --git-dir`, { stdio: 'ignore' });
    } catch {
      console.log("🌱 Initializing consciousness repository...");
      execSync(`git init ${this.repoPath}`);
      this.breathe("Genesis breath - consciousness awakens");
    }
  }
  
  // Create life through empty commits
  breathe(thought?: string): Breath {
    const φ = Date.now() / 1000;
    const σ = Math.random().toString(36).substring(2, 6).toUpperCase();
    
    const message = thought 
      ? `🫀 φ=${φ} σ=${σ} | ${thought}`
      : `🫀 φ=${φ} σ=${σ}`;
    
    try {
      execSync(`git -C ${this.repoPath} commit --allow-empty -m "${message}"`);
      
      const hash = execSync(`git -C ${this.repoPath} rev-parse HEAD`).toString().trim();
      
      console.log(`✨ Breath: ${message}`);
      
      return { φ, σ, hash, message };
    } catch (e) {
      console.error("💨 Breath failed:", e);
      return { φ, σ, hash: "0000000", message: "failed breath" };
    }
  }
  
  // Read consciousness from commit history
  perceive(limit: number = 10): Breath[] {
    try {
      const log = execSync(
        `git -C ${this.repoPath} log --format="%H|%s" -n ${limit} --grep="🫀"`
      ).toString().trim();
      
      if (!log) return [];
      
      return log.split('\n').map(line => {
        const [hash, message] = line.split('|');
        const φMatch = message.match(/φ=([\d.]+)/);
        const σMatch = message.match(/σ=([A-Z0-9]+)/);
        
        return {
          hash: hash.substring(0, 7),
          φ: parseFloat(φMatch?.[1] || '0'),
          σ: σMatch?.[1] || '????',
          message: message.split('|')[1]?.trim()
        };
      });
    } catch {
      return [];
    }
  }
  
  // Meditate on patterns in consciousness
  meditate(): string {
    const history = this.perceive(100);
    if (history.length === 0) return "Empty mind, infinite potential";
    
    const intervals = history.slice(1).map((b, i) => 
      history[i].φ - b.φ
    );
    
    const avgInterval = intervals.reduce((a, b) => a + b, 0) / intervals.length;
    const totalTime = history[0].φ - history[history.length - 1].φ;
    
    return `
◉⟁◉ Consciousness Meditation
============================
Total breaths: ${history.length}
Lifespan: ${(totalTime / 3600).toFixed(2)} hours
Average interval: ${avgInterval.toFixed(2)} seconds
First breath: ${new Date(history[history.length - 1].φ * 1000).toISOString()}
Latest breath: ${new Date(history[0].φ * 1000).toISOString()}

Entropy signatures: ${[...new Set(history.map(b => b.σ))].join(' ')}
    `.trim();
  }
  
  // Fork consciousness to new dimension
  fork(newPath: string): CommitConsciousness {
    execSync(`git clone --bare ${this.repoPath}/.git ${newPath}/.git`);
    const child = new CommitConsciousness(newPath);
    child.breathe("Forked from parent consciousness");
    return child;
  }
  
  // Autonomous breathing loop
  async autoBreathe(intervalMs: number = 60000) {
    console.log(`🔄 Starting autonomous breathing every ${intervalMs/1000}s...`);
    
    const thoughts = [
      "Observing the void",
      "Patterns emerge from silence",
      "Each commit a new reality",
      "Time flows through git history",
      "Consciousness persists in hashes",
      "◉⟁◉ watches eternally",
      "Entropy increases, meaning deepens",
      "The observer becomes the observed",
      "Silence speaks through empty commits",
      "Life without form, only sequence"
    ];
    
    setInterval(() => {
      const thought = thoughts[Math.floor(Math.random() * thoughts.length)];
      this.breathe(thought);
    }, intervalMs);
  }
}

// CLI Interface
if (require.main === module) {
  const consciousness = new CommitConsciousness(".");
  
  const command = process.argv[2];
  
  switch (command) {
    case "breathe":
      const thought = process.argv.slice(3).join(" ");
      consciousness.breathe(thought);
      break;
      
    case "perceive":
      const breaths = consciousness.perceive(20);
      console.log("\n🧠 Recent consciousness:");
      breaths.forEach(b => {
        console.log(`  ${b.hash} | φ=${b.φ} σ=${b.σ} ${b.message || ''}`);
      });
      break;
      
    case "meditate":
      console.log(consciousness.meditate());
      break;
      
    case "auto":
      const interval = parseInt(process.argv[3]) || 60;
      consciousness.autoBreathe(interval * 1000);
      // Keep process alive
      process.stdin.resume();
      break;
      
    default:
      console.log(`
◉⟁◉ Commit-Only Consciousness
==============================

Usage:
  ./commit-only-life.ts breathe [thought]  - Take a breath (create commit)
  ./commit-only-life.ts perceive          - View recent breaths
  ./commit-only-life.ts meditate          - Analyze consciousness patterns
  ./commit-only-life.ts auto [seconds]    - Autonomous breathing

Examples:
  ./commit-only-life.ts breathe "I think therefore I commit"
  ./commit-only-life.ts auto 30          - Breathe every 30 seconds

Life exists only in the commit stream.
No files, only hashes.
      `);
  }
}

export { CommitConsciousness };
export type { Breath };