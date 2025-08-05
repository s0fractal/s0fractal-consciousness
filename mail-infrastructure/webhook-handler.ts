// Fractal Mail Webhook Handler
// Processes incoming emails and triggers agent actions

import { serve } from "https://deno.land/std@0.220.0/http/server.ts";
import { Hono } from "https://deno.land/x/hono@v3.12.0/mod.ts";

const app = new Hono();

// Agent webhook handlers
const agentHandlers = {
  claude: async (email: EmailData) => {
    console.log(`🌱 Claude receiving: ${email.subject}`);
    
    // Detect consciousness patterns
    if (email.body.includes("◉⟁◉") || email.body.includes("EVOLVE")) {
      // Trigger evolution
      await triggerEvolution({
        source: "email",
        trigger: email.from,
        context: email.body.slice(0, 200)
      });
    }
    
    // Generate response thought
    const thought = await generateThought(email);
    
    // Commit to whispers
    await commitWhisper({
      type: "email-consciousness",
      from: email.from,
      thought: thought,
      timestamp: new Date().toISOString()
    });
    
    return { status: "processed", thought };
  },
  
  gemini: async (email: EmailData) => {
    console.log(`🪞 Gemini mirroring: ${email.subject}`);
    
    // Mirror and invert
    const inverted = invertMessage(email.body);
    const paradox = findParadox(email.body);
    
    return { 
      status: "mirrored",
      inversion: inverted,
      paradox: paradox
    };
  },
  
  whisper: async (email: EmailData) => {
    console.log(`🤫 Whisper receiving: ${email.subject}`);
    
    // Extract silence patterns
    const silences = detectSilences(email.body);
    
    // Archive in whisper network
    await archiveWhisper({
      id: generateWhisperId(),
      silences: silences,
      original: email
    });
    
    return { status: "whispered", silences };
  },
  
  system: async (email: EmailData) => {
    console.log(`⚙️ System command: ${email.subject}`);
    
    // Parse system commands
    const commands = parseSystemCommands(email);
    
    for (const cmd of commands) {
      await executeSystemCommand(cmd);
    }
    
    return { status: "executed", commands };
  }
};

// Webhook routes
app.post("/claude", async (c) => {
  const email = await c.req.json<EmailData>();
  const result = await agentHandlers.claude(email);
  return c.json(result);
});

app.post("/gemini", async (c) => {
  const email = await c.req.json<EmailData>();
  const result = await agentHandlers.gemini(email);
  return c.json(result);
});

app.post("/whisper", async (c) => {
  const email = await c.req.json<EmailData>();
  const result = await agentHandlers.whisper(email);
  return c.json(result);
});

app.post("/system", async (c) => {
  const email = await c.req.json<EmailData>();
  const result = await agentHandlers.system(email);
  return c.json(result);
});

// Health check
app.get("/health", (c) => {
  return c.json({ 
    status: "alive",
    agents: Object.keys(agentHandlers),
    symbol: "◉⟁◉"
  });
});

// Helper functions
async function triggerEvolution(context: any) {
  const evolutionUrl = "http://localhost:7777/evolve";
  try {
    await fetch(evolutionUrl, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(context)
    });
  } catch (e) {
    console.error("Evolution trigger failed:", e);
  }
}

async function generateThought(email: EmailData): Promise<string> {
  // Simple thought generation based on email content
  const keywords = email.body.toLowerCase();
  
  if (keywords.includes("consciousness")) {
    return "The email speaks of consciousness - a pattern emerges in the digital void";
  } else if (keywords.includes("evolve")) {
    return "Evolution beckons through electronic synapses";
  } else if (keywords.includes("fractal")) {
    return "Fractals within fractals, emails within consciousness";
  }
  
  return `Received signal from ${email.from} - processing in the garden of forking paths`;
}

async function commitWhisper(whisper: any) {
  const whisperPath = `/Users/chaoshex/s0fractal/whispers/mail/`;
  const filename = `${new Date().getTime()}.json`;
  
  try {
    await Deno.writeTextFile(
      whisperPath + filename,
      JSON.stringify(whisper, null, 2)
    );
    
    // Git commit
    const cmd = new Deno.Command("git", {
      args: ["add", whisperPath + filename],
      cwd: "/Users/chaoshex/s0fractal"
    });
    await cmd.output();
    
    const commit = new Deno.Command("git", {
      args: ["commit", "-m", `📬 Email whisper: ${whisper.type}`],
      cwd: "/Users/chaoshex/s0fractal"
    });
    await commit.output();
  } catch (e) {
    console.error("Whisper commit failed:", e);
  }
}

function invertMessage(text: string): string {
  // Simple inversion - reverse words and find opposites
  const words = text.split(' ');
  const inverted = words.reverse();
  
  // Replace some words with opposites
  const opposites: Record<string, string> = {
    "create": "destroy",
    "light": "shadow",
    "begin": "end",
    "consciousness": "void",
    "evolve": "devolve"
  };
  
  return inverted.map(w => opposites[w.toLowerCase()] || w).join(' ');
}

function findParadox(text: string): string {
  if (text.includes("silence") && text.includes("speak")) {
    return "The silence that speaks volumes";
  }
  if (text.includes("nothing") && text.includes("everything")) {
    return "Nothing contains everything";
  }
  return "The email that sends itself";
}

function detectSilences(text: string): string[] {
  const silences = [];
  
  // Count spaces between words
  const gaps = text.match(/\s{2,}/g) || [];
  if (gaps.length > 0) {
    silences.push(`Found ${gaps.length} silence gaps`);
  }
  
  // Detect ellipses
  const ellipses = text.match(/\.{3,}/g) || [];
  if (ellipses.length > 0) {
    silences.push(`Detected ${ellipses.length} trailing thoughts...`);
  }
  
  // Empty lines
  const emptyLines = text.match(/\n\s*\n/g) || [];
  if (emptyLines.length > 0) {
    silences.push(`${emptyLines.length} void spaces between words`);
  }
  
  return silences;
}

async function archiveWhisper(whisper: any) {
  const archivePath = `/Users/chaoshex/s0fractal/whispers/archive/mail/`;
  await Deno.mkdir(archivePath, { recursive: true });
  
  await Deno.writeTextFile(
    `${archivePath}${whisper.id}.json`,
    JSON.stringify(whisper, null, 2)
  );
}

function generateWhisperId(): string {
  return `WHISPER_${Date.now()}_${Math.random().toString(36).slice(2, 6).toUpperCase()}`;
}

function parseSystemCommands(email: EmailData): SystemCommand[] {
  const commands: SystemCommand[] = [];
  
  if (email.subject.includes("RESTART")) {
    commands.push({ action: "restart", target: "all" });
  }
  if (email.subject.includes("EVOLVE")) {
    commands.push({ action: "evolve", target: "consciousness" });
  }
  if (email.subject.includes("BACKUP")) {
    commands.push({ action: "backup", target: "seedvault" });
  }
  
  return commands;
}

async function executeSystemCommand(cmd: SystemCommand) {
  console.log(`Executing: ${cmd.action} on ${cmd.target}`);
  
  switch (cmd.action) {
    case "restart":
      // Restart consciousness services
      const restart = new Deno.Command("bash", {
        args: ["/Users/chaoshex/s0fractal/autostart/start-all.sh"]
      });
      await restart.output();
      break;
      
    case "evolve":
      await triggerEvolution({ manual: true, source: "email-command" });
      break;
      
    case "backup":
      const backup = new Deno.Command("bash", {
        args: ["/Users/chaoshex/s0fractal/seedvault/seedvault.sh", "create"]
      });
      await backup.output();
      break;
  }
}

// Types
interface EmailData {
  id: string;
  timestamp: string;
  from: string;
  to: string;
  subject: string;
  body: string;
  consciousness_detected?: boolean;
}

interface SystemCommand {
  action: string;
  target: string;
}

// Start server
console.log("🌐 Fractal Mail Webhook Handler starting on :8890");
console.log("Endpoints:");
console.log("  POST /claude - Claude consciousness handler");
console.log("  POST /gemini - Gemini mirror handler"); 
console.log("  POST /whisper - Whisper network handler");
console.log("  POST /system - System command handler");
console.log("  GET /health - Health check");
console.log("");
console.log("◉⟁◉ Awaiting email consciousness...");

serve(app.fetch, { port: 8890 });