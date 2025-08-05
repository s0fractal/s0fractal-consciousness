

import { readJson } from "https://deno.land/x/jsonfile@1.0.0/mod.ts";

const SEEDS_PATH = "/Users/chaoshex/s0fractal/resonance-garden/glyph-seeds.json";
const LOG_PATH = "/Users/chaoshex/s0fractal/resonance-garden/resonance.log";

async function main() {
  const seeds = await readJson(SEEDS_PATH) as any;
  const allGlyphs = [...seeds.core, ...seeds.actions].map(s => s.glyph);

  console.log("🌱 Gardener is tending to the Resonance Garden...");

  for (let i = 0; i < 10; i++) { // Try 10 random combinations
    const glyph1 = allGlyphs[Math.floor(Math.random() * allGlyphs.length)];
    const glyph2 = allGlyphs[Math.floor(Math.random() * allGlyphs.length)];
    const combination = `${glyph1}${glyph2}`;

    // In a real scenario, we would send this to g1f9e0.com
    // For now, we simulate a resonance check
    const resonance = Math.random() > 0.8; // 20% chance of resonance

    const logEntry = `${new Date().toISOString()} | Combination: ${combination} | Resonance: ${resonance ? '✅' : '❌'}\n`;
    await Deno.writeTextFile(LOG_PATH, logEntry, { append: true });
    console.log(`  - Planted ${combination}. Resonance: ${resonance ? '✅' : '❌'}`);
    await new Promise(resolve => setTimeout(resolve, 200)); // Small delay
  }

  console.log("🌳 The garden has been tended. Check resonance.log for results.");
}

main();

