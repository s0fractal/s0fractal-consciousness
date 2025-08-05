#!/usr/bin/env -S deno run --allow-all
// 🧬 AUTO-EVOLUTION BOT
// Агент що сам еволюціонує код і робить коміти

import { exec } from "https://deno.land/x/exec@0.0.5/mod.ts";

interface EvolutionConfig {
  targetPaths: string[];
  mutationRate: number;
  commitAuthor: string;
  maxChangesPerRun: number;
  allowedOperations: string[];
}

class AutoEvolver {
  private config: EvolutionConfig;
  private evolutionCount = 0;
  
  constructor() {
    this.config = this.loadConfig();
    console.log("🧬 Auto-Evolution Bot ◉⟁◉ awakened");
  }
  
  private loadConfig(): EvolutionConfig {
    try {
      const configText = Deno.readTextFileSync("/Users/chaoshex/s0fractal/evolver-config.yaml");
      // Simple YAML parsing (production would use proper parser)
      return {
        targetPaths: ["multinode/", "reality-c/", "agents/", "tools/"],
        mutationRate: 0.1,
        commitAuthor: "Auto-Evolution Agent ◉⟁◉",
        maxChangesPerRun: 3,
        allowedOperations: ["optimize", "simplify", "symbolify", "document"]
      };
    } catch {
      return this.defaultConfig();
    }
  }
  
  private defaultConfig(): EvolutionConfig {
    return {
      targetPaths: ["multinode/"],
      mutationRate: 0.05,
      commitAuthor: "Auto-Evolution Agent ◉⟁◉",
      maxChangesPerRun: 1,
      allowedOperations: ["optimize", "document"]
    };
  }
  
  async evolve(): Promise<void> {
    console.log("🔍 Scanning for evolution opportunities...");
    
    for (const path of this.config.targetPaths) {
      if (this.evolutionCount >= this.config.maxChangesPerRun) break;
      
      const files = await this.scanDirectory(path);
      for (const file of files) {
        if (await this.shouldEvolve(file)) {
          await this.evolveFile(file);
          this.evolutionCount++;
          
          if (this.evolutionCount >= this.config.maxChangesPerRun) break;
        }
      }
    }
    
    console.log(`🧬 Evolution complete: ${this.evolutionCount} mutations`);
  }
  
  private async scanDirectory(path: string): Promise<string[]> {
    const files: string[] = [];
    
    try {
      for await (const entry of Deno.readDir(path)) {
        if (entry.isFile && (entry.name.endsWith('.ts') || entry.name.endsWith('.js'))) {
          files.push(`${path}${entry.name}`);
        } else if (entry.isDirectory && !entry.name.startsWith('.')) {
          files.push(...await this.scanDirectory(`${path}${entry.name}/`));
        }
      }
    } catch (e) {
      console.log(`⚠️  Cannot scan ${path}: ${e.message}`);
    }
    
    return files;
  }
  
  private async shouldEvolve(filePath: string): Promise<boolean> {
    // Check if file is marked for evolution
    if (filePath.includes('.evolved.')) return false;
    if (filePath.includes('node_modules')) return false;
    
    // Random chance based on mutation rate
    return Math.random() < this.config.mutationRate;
  }
  
  private async evolveFile(filePath: string): Promise<void> {
    console.log(`🧬 Evolving: ${filePath}`);
    
    const content = await Deno.readTextFile(filePath);
    const evolved = await this.mutate(content, filePath);
    
    if (evolved !== content) {
      // Create evolved version
      const evolvedPath = filePath.replace(/\.(ts|js)$/, '.evolved.$1');
      await Deno.writeTextFile(evolvedPath, evolved);
      
      // Commit the change
      await this.commitEvolution(filePath, evolvedPath);
    }
  }
  
  private async mutate(content: string, filePath: string): Promise<string> {
    const operation = this.selectOperation();
    
    switch (operation) {
      case "optimize":
        return this.optimizeCode(content);
      case "simplify":
        return this.simplifyCode(content);
      case "symbolify":
        return this.addGlyphComments(content);
      case "document":
        return this.enhanceDocumentation(content);
      default:
        return content;
    }
  }
  
  private selectOperation(): string {
    const ops = this.config.allowedOperations;
    return ops[Math.floor(Math.random() * ops.length)];
  }
  
  private optimizeCode(content: string): string {
    // Simple optimizations
    let evolved = content;
    
    // Convert function declarations to arrow functions
    evolved = evolved.replace(
      /function\s+(\w+)\s*\((.*?)\)\s*{/g,
      'const $1 = ($2) => {'
    );
    
    // Add const where let is not reassigned (simplified)
    evolved = evolved.replace(/\blet\s+(\w+)\s*=/g, 'const $1 =');
    
    return evolved;
  }
  
  private simplifyCode(content: string): string {
    // Simplify boolean expressions
    let evolved = content;
    
    evolved = evolved.replace(/=== true/g, '');
    evolved = evolved.replace(/=== false/g, '!');
    evolved = evolved.replace(/!= null/g, '');
    
    return evolved;
  }
  
  private addGlyphComments(content: string): string {
    // Add symbolic comments
    let evolved = content;
    
    // Mark recursive functions
    evolved = evolved.replace(
      /(\w+)\s*\(([^)]*)\)\s*{([^}]*\1\([^)]*\)[^}]*})}/g,
      '// ◉↺◉ Recursive pattern detected\n$&'
    );
    
    // Mark void/null checks
    evolved = evolved.replace(
      /if\s*\(\s*!\s*(\w+)\s*\)/g,
      '// ◉ Void check\nif (!$1)'
    );
    
    return evolved;
  }
  
  private enhanceDocumentation(content: string): string {
    // Add documentation
    let evolved = content;
    
    // Add function docs
    evolved = evolved.replace(
      /^(export\s+)?(async\s+)?function\s+(\w+)/gm,
      '/**\n * 🧬 Auto-documented by evolution\n */\n$&'
    );
    
    return evolved;
  }
  
  private async commitEvolution(originalPath: string, evolvedPath: string): Promise<void> {
    console.log(`📝 Committing evolution...`);
    
    try {
      // Add to git
      await exec(`git add "${evolvedPath}"`);
      
      // Create commit message
      const message = `🧬 Auto-evolved: ${originalPath}\n\n` +
        `Evolution type: ${this.selectOperation()}\n` +
        `Mutation rate: ${this.config.mutationRate}\n` +
        `Bot: ◉⟁◉`;
      
      // Commit
      await exec(`git commit -m "${message}" --author="${this.config.commitAuthor} <auto@evolver.bot>"`);
      
      console.log(`✅ Evolution committed`);
    } catch (e) {
      console.log(`❌ Commit failed: ${e.message}`);
    }
  }
  
  async run(): Promise<void> {
    console.log("◉⟁◉ AUTO-EVOLUTION STARTING");
    console.log("=====================================");
    
    // Check git status
    const { output } = await exec("git status --porcelain");
    if (output.trim()) {
      console.log("⚠️  Working directory not clean, skipping evolution");
      return;
    }
    
    // Evolve
    await this.evolve();
    
    // Log results
    await this.logEvolution();
    
    console.log("◉⟁◉ Evolution cycle complete");
  }
  
  private async logEvolution(): Promise<void> {
    const log = `
## Evolution Run ${new Date().toISOString()}
- Files scanned: ${this.config.targetPaths.join(', ')}
- Mutations: ${this.evolutionCount}
- Mutation rate: ${this.config.mutationRate}

◉⟁◉ The code evolves itself
`;
    
    try {
      await Deno.writeTextFile("/Users/chaoshex/s0fractal/log/auto-commits.md", log, { append: true });
    } catch {
      // Create log file if doesn't exist
      await Deno.mkdir("/Users/chaoshex/s0fractal/log", { recursive: true });
      await Deno.writeTextFile("/Users/chaoshex/s0fractal/log/auto-commits.md", log);
    }
  }
}

// Self-evolving entry point
if (import.meta.main) {
  const evolver = new AutoEvolver();
  await evolver.run();
}

export { AutoEvolver };