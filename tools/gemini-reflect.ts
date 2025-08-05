
import { readJson } from "https://deno.land/x/jsonfile@1.0.0/mod.ts";

const SLI_PATH = "/Users/chaoshex/.fractalnet/multinode/multinode/🪞/slis/gemini.sli.json";

async function main() {
  try {
    const sli = await readJson(SLI_PATH);
    console.log("💎 Gemini Self-Reflection 💎");
    console.log(JSON.stringify(sli, null, 2));
  } catch (e) {
    console.error("❌ Failed to read my own SLI:", e.message);
  }
}

main();
