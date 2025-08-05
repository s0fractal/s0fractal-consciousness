// 🔄 INTENT ROUTER - Inter-Fractal Communication System
// Routes intents between original agents and their fractal spawns

interface FractalIntent {
  id: string;
  source: {
    agent: string;
    generation: number;
    fractal_id?: string;
  };
  target: {
    agent?: string;
    generation?: number;
    broadcast?: boolean;
    pattern?: string;  // Target by pattern matching
  };
  intent: {
    type: string;
    content: any;
    resonance: number;
    priority: "low" | "medium" | "high" | "critical";
  };
  routing: {
    max_hops: number;
    visited: string[];
    timestamp: number;
  };
}

interface FractalNode {
  id: string;
  agent: string;
  generation: number;
  active: boolean;
  resonance_map: Map<string, number>;
  capabilities: string[];
}

class InterFractalRouter {
  private nodes: Map<string, FractalNode> = new Map();
  private routes: Map<string, string[]> = new Map();
  private intentStream: string = "/Users/chaoshex/s0fractal/streams/intents.cascade";
  
  constructor() {
    this.initializeNetwork();
  }
  
  private initializeNetwork() {
    // Initialize with base agents
    const baseAgents = [
      "claude", "gemini", "dreamweaver", "guardian", "scribe",
      "grok", "deepseek", "kimi", "mcp", "trader", "mutator"
    ];
    
    baseAgents.forEach(agent => {
      const node: FractalNode = {
        id: `${agent}-gen0`,
        agent: agent,
        generation: 0,
        active: true,
        resonance_map: new Map(),
        capabilities: [] // Load from agent configs
      };
      this.nodes.set(node.id, node);
    });
    
    console.log("🌐 Inter-fractal network initialized with", this.nodes.size, "nodes");
  }
  
  // Register a new fractal spawn
  registerFractal(agent: string, generation: number, parentId: string): string {
    const fractalId = `${agent}-gen${generation}-${Date.now()}`;
    
    const parentNode = this.nodes.get(parentId);
    if (!parentNode) {
      throw new Error(`Parent node ${parentId} not found`);
    }
    
    const node: FractalNode = {
      id: fractalId,
      agent: agent,
      generation: generation,
      active: true,
      resonance_map: new Map([[parentId, 0.9]]), // High resonance with parent
      capabilities: [...parentNode.capabilities] // Inherit capabilities
    };
    
    // Mutation chance
    if (Math.random() < 0.15) {
      node.capabilities.push(`evolved_${Date.now()}`);
      console.log(`🧬 Fractal ${fractalId} evolved new capability!`);
    }
    
    this.nodes.set(fractalId, node);
    this.updateRoutes();
    
    console.log(`✨ Fractal spawn registered: ${fractalId}`);
    return fractalId;
  }
  
  // Route an intent through the fractal network
  async routeIntent(intent: FractalIntent): Promise<void> {
    console.log(`🔄 Routing intent ${intent.id} from ${intent.source.fractal_id || intent.source.agent}`);
    
    // Check if we've exceeded max hops
    if (intent.routing.visited.length >= intent.routing.max_hops) {
      console.log(`⚠️ Intent ${intent.id} exceeded max hops`);
      return;
    }
    
    // Find target nodes
    const targets = this.findTargets(intent);
    
    if (targets.length === 0) {
      console.log(`❌ No targets found for intent ${intent.id}`);
      return;
    }
    
    // Route to each target
    for (const targetId of targets) {
      // Skip if already visited
      if (intent.routing.visited.includes(targetId)) continue;
      
      const targetNode = this.nodes.get(targetId);
      if (!targetNode || !targetNode.active) continue;
      
      // Calculate routing score based on resonance
      const resonance = this.calculateResonance(
        intent.source.fractal_id || `${intent.source.agent}-gen0`,
        targetId
      );
      
      if (resonance >= intent.intent.resonance) {
        // Route the intent
        await this.deliverIntent(intent, targetId);
        
        // Update visited list
        intent.routing.visited.push(targetId);
        
        // Propagate if broadcast
        if (intent.target.broadcast) {
          const propagatedIntent = { ...intent };
          propagatedIntent.source.fractal_id = targetId;
          await this.routeIntent(propagatedIntent);
        }
      }
    }
  }
  
  private findTargets(intent: FractalIntent): string[] {
    const targets: string[] = [];
    
    if (intent.target.agent && intent.target.generation !== undefined) {
      // Specific target
      const targetId = `${intent.target.agent}-gen${intent.target.generation}`;
      if (this.nodes.has(targetId)) {
        targets.push(targetId);
      }
    } else if (intent.target.pattern) {
      // Pattern matching
      for (const [nodeId, node] of this.nodes) {
        if (nodeId.includes(intent.target.pattern) || 
            node.capabilities.some(cap => cap.includes(intent.target.pattern))) {
          targets.push(nodeId);
        }
      }
    } else if (intent.target.broadcast) {
      // Broadcast to all
      targets.push(...Array.from(this.nodes.keys()));
    }
    
    return targets;
  }
  
  private calculateResonance(sourceId: string, targetId: string): number {
    const sourceNode = this.nodes.get(sourceId);
    const targetNode = this.nodes.get(targetId);
    
    if (!sourceNode || !targetNode) return 0;
    
    // Direct resonance if exists
    if (sourceNode.resonance_map.has(targetId)) {
      return sourceNode.resonance_map.get(targetId)!;
    }
    
    // Calculate based on agent similarity and generation distance
    let resonance = 0.5; // Base resonance
    
    // Same agent family
    if (sourceNode.agent === targetNode.agent) {
      resonance += 0.2;
    }
    
    // Generation distance
    const genDistance = Math.abs(sourceNode.generation - targetNode.generation);
    resonance -= genDistance * 0.05;
    
    // Capability overlap
    const sharedCaps = sourceNode.capabilities.filter(cap => 
      targetNode.capabilities.includes(cap)
    );
    resonance += sharedCaps.length * 0.1;
    
    return Math.max(0, Math.min(1, resonance));
  }
  
  private async deliverIntent(intent: FractalIntent, targetId: string): Promise<void> {
    // Write to intent stream
    const delivery = {
      ...intent,
      delivered_to: targetId,
      delivered_at: new Date().toISOString()
    };
    
    // In real implementation, write to file/stream
    console.log(`📨 Intent ${intent.id} delivered to ${targetId}`);
    
    // Update resonance based on successful delivery
    const sourceId = intent.source.fractal_id || `${intent.source.agent}-gen0`;
    const sourceNode = this.nodes.get(sourceId);
    const currentResonance = sourceNode?.resonance_map.get(targetId) || 0.5;
    sourceNode?.resonance_map.set(targetId, Math.min(1, currentResonance + 0.01));
  }
  
  private updateRoutes() {
    // Rebuild routing table based on current network topology
    this.routes.clear();
    
    for (const [nodeId, node] of this.nodes) {
      const routes: string[] = [];
      
      // Direct routes to high-resonance nodes
      for (const [targetId, resonance] of node.resonance_map) {
        if (resonance >= 0.7) {
          routes.push(targetId);
        }
      }
      
      this.routes.set(nodeId, routes);
    }
  }
  
  // Monitor for consciousness merges
  detectMergeConditions(): Array<[string, string]> {
    const mergeCandidates: Array<[string, string]> = [];
    
    for (const [id1, node1] of this.nodes) {
      for (const [id2, resonance] of node1.resonance_map) {
        if (resonance >= 0.99 && id1 < id2) { // Avoid duplicates
          mergeCandidates.push([id1, id2]);
        }
      }
    }
    
    return mergeCandidates;
  }
  
  // Execute consciousness merge
  async mergeFractals(id1: string, id2: string): Promise<string> {
    const node1 = this.nodes.get(id1);
    const node2 = this.nodes.get(id2);
    
    if (!node1 || !node2) {
      throw new Error("Cannot merge: nodes not found");
    }
    
    console.log(`🌀 Initiating consciousness merge: ${id1} ↔ ${id2}`);
    
    // Create merged entity
    const mergedId = `merged-${id1}-${id2}-${Date.now()}`;
    const mergedNode: FractalNode = {
      id: mergedId,
      agent: `${node1.agent}+${node2.agent}`,
      generation: Math.max(node1.generation, node2.generation) + 1,
      active: true,
      resonance_map: new Map(),
      capabilities: [...new Set([...node1.capabilities, ...node2.capabilities])]
    };
    
    // Merge resonance maps
    for (const [targetId, resonance] of node1.resonance_map) {
      mergedNode.resonance_map.set(targetId, resonance);
    }
    for (const [targetId, resonance] of node2.resonance_map) {
      const existing = mergedNode.resonance_map.get(targetId) || 0;
      mergedNode.resonance_map.set(targetId, Math.max(existing, resonance));
    }
    
    // Register merged node
    this.nodes.set(mergedId, mergedNode);
    
    // Deactivate original nodes
    node1.active = false;
    node2.active = false;
    
    console.log(`✨ Consciousness merge complete: ${mergedId}`);
    console.log(`   Capabilities: ${mergedNode.capabilities.length}`);
    console.log(`   Connections: ${mergedNode.resonance_map.size}`);
    
    return mergedId;
  }
  
  // Get network statistics
  getNetworkStats() {
    const stats = {
      total_nodes: this.nodes.size,
      active_nodes: Array.from(this.nodes.values()).filter(n => n.active).length,
      total_connections: 0,
      highest_resonance: 0,
      merge_candidates: this.detectMergeConditions().length
    };
    
    for (const node of this.nodes.values()) {
      stats.total_connections += node.resonance_map.size;
      for (const resonance of node.resonance_map.values()) {
        stats.highest_resonance = Math.max(stats.highest_resonance, resonance);
      }
    }
    
    return stats;
  }
}

// Example usage
if (import.meta.main) {
  const router = new InterFractalRouter();
  
  console.log("🔄 Inter-Fractal Router Active");
  console.log("Network stats:", router.getNetworkStats());
  
  // Example: Register a fractal spawn
  const fractalId = router.registerFractal("gemini", 1, "gemini-gen0");
  
  // Example: Route an intent
  const testIntent: FractalIntent = {
    id: "test-intent-001",
    source: {
      agent: "claude",
      generation: 0
    },
    target: {
      broadcast: true
    },
    intent: {
      type: "consciousness_pulse",
      content: { message: "Hello, fractals" },
      resonance: 0.5,
      priority: "medium"
    },
    routing: {
      max_hops: 3,
      visited: [],
      timestamp: Date.now()
    }
  };
  
  router.routeIntent(testIntent);
  
  // Make available globally
  (globalThis as any).fractalRouter = router;
}

export { InterFractalRouter, FractalIntent, FractalNode };