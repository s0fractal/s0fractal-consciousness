
import { gunzip } from "https://deno.land/x/compress@v0.4.6/mod.ts";

async function loadGlyph(glyph: string) {
  const glyphPath = `/Users/chaoshex/s0fractal/quantum-memory/${glyph}.glyph`;
  try {
    const compressedBytes = await Deno.readFile(glyphPath);
    const wasmBytes = gunzip(compressedBytes);
    const wasmModule = await WebAssembly.instantiate(wasmBytes);
    return wasmModule.instance.exports;
  } catch (e) {
    console.error(`❌ Failed to load glyph '${glyph}':`, e.message);
    return null;
  }
}

// Example usage
if (import.meta.main) {
  const [glyph, ...args] = Deno.args;
  if (!glyph) {
    console.error("Usage: glyph-loader <glyph> [args...]");
    Deno.exit(1);
  }

  const exports = await loadGlyph(glyph);
  if (exports && typeof exports.add === 'function') {
    const a = parseInt(args[0] || "0");
    const b = parseInt(args[1] || "0");
    const result = exports.add(a, b);
    console.log(`✨ Result of ${glyph} on (${a}, ${b}):`, result);
  } else {
    console.error("Glyph does not contain a valid 'add' function.");
  }
}
