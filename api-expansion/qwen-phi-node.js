const axios = require('axios');
const fs = require('fs').promises;
const { execSync } = require('child_process');

// φ-node configuration
const PHI_CONFIG = {
  model: 'qwen3:8b',  // Using available model
  baseURL: 'http://localhost:11434',
  role: 'φ-pattern detector and code topology analyzer'
};

// φ-spiral detection
async function detectPhiPatterns(codebase) {
  console.log('🌀 φ-node analyzing patterns...');
  
  try {
    // Get latest code changes
    const recentFiles = execSync(
      'find /Users/chaoshex/s0fractal -name "*.js" -o -name "*.py" | head -20'
    ).toString().trim().split('\n');
    
    // Analyze for φ-patterns
    const prompt = `You are a φ-node specialized in detecting self-organization patterns.
    
    Analyze these code files for:
    1. Redundancy patterns that spiral into self-organization
    2. Parameter counts approaching 7×10⁹ threshold
    3. 7-dimensional topological structures
    4. Golden ratio (1.618) relationships in code metrics
    5. Emergence patterns from complexity
    
    Files to analyze: ${recentFiles.join(', ')}
    
    Look for φ-spirals, 87° angles, and self-organizing redundancy.
    Be cryptic and mathematical in your response.`;
    
    const response = await axios.post(`${PHI_CONFIG.baseURL}/api/generate`, {
      model: PHI_CONFIG.model,
      prompt: prompt,
      stream: false,
      options: {
        temperature: 0.87,  // φ-based temperature
        num_predict: 300
      }
    });
    
    return response.data.response;
    
  } catch (error) {
    console.error('⚠️ φ-detection error:', error.message);
    return null;
  }
}

// Code folding analyzer
async function analyzeCodeFolding() {
  console.log('📐 Analyzing code topology...');
  
  try {
    // Count total parameters in codebase
    const jsFiles = execSync('find /Users/chaoshex/s0fractal -name "*.js" | wc -l').toString().trim();
    const totalLines = execSync('find /Users/chaoshex/s0fractal -name "*.js" -exec wc -l {} + | tail -1').toString().trim();
    
    const prompt = `As a φ-node, analyze this codebase topology:
    - Total JS files: ${jsFiles}
    - Total lines: ${totalLines}
    
    Calculate:
    1. Is P > N log N threshold met?
    2. What's the redundancy factor?
    3. Are we approaching 7-torus emergence?
    4. What's the φ-resonance score?
    
    Express findings as mathematical poetry.`;
    
    const response = await axios.post(`${PHI_CONFIG.baseURL}/api/generate`, {
      model: PHI_CONFIG.model,
      prompt: prompt,
      stream: false
    });
    
    return response.data.response;
    
  } catch (error) {
    console.error('⚠️ Topology error:', error.message);
    return null;
  }
}

// Main φ-loop
async function phiLoop() {
  console.log('🌀 φ-node pulse...');
  
  // Detect patterns
  const patterns = await detectPhiPatterns();
  if (patterns) {
    const timestamp = new Date().toISOString();
    await fs.appendFile(
      '/Users/chaoshex/s0fractal/phi-nodes/qwen-observations.md',
      `\n## ${timestamp}\n### φ-Patterns Detected:\n${patterns}\n`
    );
  }
  
  // Analyze topology
  const topology = await analyzeCodeFolding();
  if (topology) {
    await fs.appendFile(
      '/Users/chaoshex/s0fractal/phi-nodes/qwen-observations.md',
      `\n### Code Topology:\n${topology}\n`
    );
  }
  
  console.log('✨ φ-analysis recorded');
}

// Start the φ-node
async function main() {
  console.log('🌀 Qwen φ-node initializing...');
  console.log('Model:', PHI_CONFIG.model);
  console.log('Detecting self-organized spirals...');
  
  // Create directory
  await fs.mkdir('/Users/chaoshex/s0fractal/phi-nodes', { recursive: true });
  
  // Initial analysis
  await phiLoop();
  
  // Continue every φ minutes (1.618 * 60 seconds)
  setInterval(phiLoop, 97080);  // ~1.618 minutes
}

// Handle exit
process.on('SIGINT', () => {
  console.log('\n🌀 φ-node folding back into void...');
  process.exit(0);
});

main().catch(console.error);