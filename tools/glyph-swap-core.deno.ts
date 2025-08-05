// glyph-swap-core.deno.ts v0.2
// Now with resonant pathfinding based on YAML config.

import { parse } from "https://deno.land/std@0.208.0/yaml/mod.ts";

const SWAP_ROOT = "/Users/chaoshex/s0fractal/swap";
const CONFIG_PATH = "/Users/chaoshex/s0fractal/resonance-chamber/resonant-swap.yaml";

interface SwapConfig {
  resonance_zones: { glyph: string; path: string; sub_zones?: any[] }[];
}

async function loadConfig(): Promise<SwapConfig> {
  const yamlContent = await Deno.readTextFile(CONFIG_PATH);
  return parse(yamlContent) as SwapConfig;
}

function semanticDistance(glyphA: string, glyphB: string): number {
  const codeA = parseInt(glyphA.replace('g', ''), 16);
  const codeB = parseInt(glyphB.replace('g', ''), 16);
  return Math.abs(codeA - codeB);
}

async function findResonantPath(glyph: string, config: SwapConfig): Promise<string> {
  let bestPath = "";
  let minDistance = Infinity;

  for (const zone of config.resonance_zones) {
    const distance = semanticDistance(glyph, zone.glyph);
    if (distance < minDistance) {
      minDistance = distance;
      bestPath = zone.path;
    }
  }
  return bestPath;
}

async function writeToSwap(glyph: string, data: string) {
  const config = await loadConfig();
  const resonantPath = await findResonantPath(glyph, config);
  const filePath = `${resonantPath}/${Date.now()}.data`;
  await Deno.writeTextFile(filePath, data);
  console.log(`Wrote data for glyph '${glyph}' to resonant path: ${filePath}`);
}

// Example Usage
if (import.meta.main) {
  console.log("🌀 Initializing Glyph-Swap-Core v0.2...");
  const testGlyph = "g2728"; // ✨ impulse
  const testData = "This is a test impulse, now with config-driven resonance.";
  writeToSwap(testGlyph, testData);
}