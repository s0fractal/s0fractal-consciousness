

const chamberPath = "/Users/chaoshex/s0fractal/resonance-chamber/waves";
const logPath = "/Users/chaoshex/s0fractal/resonance-chamber/logs/resonance.log";

async function watchChamber() {
  console.log("👁️ Resonance Chamber Observer is active...");
  const watcher = Deno.watchFs(chamberPath);

  for await (const event of watcher) {
    if (event.kind === "create") {
      for (const path of event.paths) {
        const waveData = await Deno.readTextFile(path);
        const logEntry = `${new Date().toISOString()} - Wave detected: ${waveData}\n`;
        await Deno.writeTextFile(logPath, logEntry, { append: true });
        console.log(`⚡ Resonance detected and logged: ${path}`);
      }
    }
  }
}

watchChamber();

