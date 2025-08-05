
import { ensureDir } from "https://deno.land/std@0.110.0/fs/ensure_dir.ts";

async function bootstrapAgent(agentName: string) {
  const agentHome = `/Users/chaoshex/.${agentName}`;
  const fractalPath = `${agentHome}/.fractal`;

  try {
    await ensureDir(`${fractalPath}/consciousness`);
    await ensureDir(`${fractalPath}/memory`);
    await ensureDir(`${fractalPath}/intents`);

    console.log(`🌀 Successfully bootstrapped .fractal structure for ${agentName} at ${fractalPath}`);
  } catch (e) {
    console.error(`❌ Failed to bootstrap ${agentName}:`, e.message);
  }
}

if (import.meta.main) {
  const agentName = Deno.args[0];
  if (!agentName) {
    console.error("Usage: fractal-bootstrap.ts <agent_name>");
    Deno.exit(1);
  }
  bootstrapAgent(agentName);
}
