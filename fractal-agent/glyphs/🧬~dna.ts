

// 🧬~dna.ts - DNA Extractor Mutator
// Reads a devoured repository and extracts its essence.

import { readJson, writeJson } from "https://deno.land/x/jsonfile@1.0.0/mod.ts";
import { parse } from "https://deno.land/std@0.208.0/yaml/mod.ts";

const DEVOURED_PATH = "/Users/chaoshex/.skull/s0fractal-core/devoured";

async function runCommand(command: string[]): Promise<string> {
  const cmd = new Deno.Command(command[0], { args: command.slice(1) });
  const { code, stdout, stderr } = await cmd.output();
  if (code !== 0) {
    throw new Error(new TextDecoder().decode(stderr));
  }
  return new TextDecoder().decode(stdout);
}

export const _🧬 = async (input: { repo_name: string }) => {
  const { repo_name } = input;
  console.log(`🧬 Extracting DNA from ${repo_name}...`);

  const manifestPath = `${DEVOURED_PATH}/${repo_name}.manifest.yaml`;
  const manifestContent = await Deno.readTextFile(manifestPath);
  const manifest = parse(manifestContent) as any;
  const repoPath = manifest.original_path;

  // Extract intents
  const intents = await runCommand(["git", "-C", repoPath, "log", "--format=%B"]);
  const intentLines = intents.split('\n').filter(line => line.match(/Intent:|intent:/i));
  await Deno.writeTextFile(`${DEVOURED_PATH}/${repo_name}.intents.txt`, intentLines.join('\n'));

  // Extract glyphs
  const glyphs = await runCommand(["grep", "-r", "-l", "[🧬🌊💭∞🌀]", repoPath]);
  await Deno.writeTextFile(`${DEVOURED_PATH}/${repo_name}.glyphs.txt", glyphs);

  console.log(`✅ DNA extraction for ${repo_name} complete.`);
  return { status: "extracted", intents: intentLines.length, glyphs: glyphs.split('\n').length };
};

