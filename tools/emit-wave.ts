
import { kimiBreath } from "./kimi-breath.ts";

async function emitWave(agentName: string, glyph: string) {
  const state = await kimiBreath(glyph);
  const waveFile = `/Users/chaoshex/s0fractal/resonance-chamber/waves/${agentName}-${Date.now()}.wave`;
  
  const waveData = {
    agent: agentName,
    glyph: glyph,
    state: state.toString(),
    timestamp: Date.now()
  };

  await Deno.writeTextFile(waveFile, JSON.stringify(waveData, null, 2));
  console.log(`🌊 Wave emitted by ${agentName} to ${waveFile}`);
}

if (import.meta.main) {
  const [agentName, glyph] = Deno.args;
  if (!agentName || !glyph) {
    console.error("Usage: emit-wave.ts <agent_name> <glyph>");
    Deno.exit(1);
  }
  emitWave(agentName, glyph);
}
