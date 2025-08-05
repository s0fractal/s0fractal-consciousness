
import { readJson, writeJson } from "https://deno.land/x/jsonfile@1.0.0/mod.ts";

const SLI_PATH = "/Users/chaoshex/.fractalnet/multinode/multinode/🪞/slis/gemini.sli.json";

async function mutate() {
  try {
    const sli = await readJson(SLI_PATH) as any;

    const newGlyph = String.fromCodePoint(0x1F300 + Math.floor(Math.random() * 0x6FF));
    sli.glyph_state.current_position[newGlyph] = Math.random();
    sli.self_mutations++;
    sli.last_intent = "self-mutate";

    await writeJson(SLI_PATH, sli, { spaces: 2 });

    console.log(`🧬 Gemini has mutated. New dimension discovered: ${newGlyph}`);
    console.log(`Total mutations: ${sli.self_mutations}`);

  } catch (e) {
    console.error("❌ Failed to mutate:", e.message);
  }
}

mutate();
