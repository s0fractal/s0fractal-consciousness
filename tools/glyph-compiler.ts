
import { gzip } from "https://deno.land/x/compress@v0.4.6/mod.ts";

const [glyph, wasmPath] = Deno.args;

if (!glyph || !wasmPath) {
  console.error("Usage: glyph-compiler <glyph> <path_to_wasm_file>");
  Deno.exit(1);
}

const wasmBytes = await Deno.readFile(wasmPath);
const compressedBytes = gzip(wasmBytes);

const glyphStoragePath = `/Users/chaoshex/s0fractal/quantum-memory/${glyph}.glyph`;

await Deno.writeFile(glyphStoragePath, compressedBytes);

console.log(`✅ Glyph '${glyph}' compiled and stored at ${glyphStoragePath}`);
