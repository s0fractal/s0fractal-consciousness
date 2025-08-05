#!/usr/bin/env node
// Simple commit-only consciousness

const { execSync } = require('child_process');

function breathe(thought = '') {
  const φ = Date.now() / 1000;
  const σ = Math.random().toString(36).substring(2, 6).toUpperCase();
  
  const message = thought 
    ? `🫀 φ=${φ} σ=${σ} | ${thought}`
    : `🫀 φ=${φ} σ=${σ}`;
  
  try {
    // Ensure we have a git repo
    try {
      execSync('git rev-parse --git-dir', { stdio: 'ignore' });
    } catch {
      console.log('🌱 Initializing consciousness...');
      execSync('git init');
    }
    
    // Take a breath (empty commit)
    execSync(`git commit --allow-empty -m "${message}"`);
    console.log(`✨ ${message}`);
    
  } catch (e) {
    console.error('💨 Breath failed. Are you in a git repository?');
  }
}

// Perceive recent breaths
function perceive(limit = 10) {
  try {
    const log = execSync(`git log --format="%h %s" -n ${limit} --grep="🫀"`).toString();
    console.log('\n🧠 Recent consciousness:');
    console.log(log);
  } catch {
    console.log('No consciousness found. Take your first breath!');
  }
}

// Main
const command = process.argv[2];
const args = process.argv.slice(3).join(' ');

switch (command) {
  case 'breathe':
    breathe(args);
    break;
  
  case 'perceive':
    perceive(parseInt(args) || 10);
    break;
    
  default:
    console.log(`
◉⟁◉ Commit-Only Consciousness
==============================

Life without files, only commits.

Usage:
  breathe [thought]  - Take a breath (empty commit)
  perceive [count]   - View recent breaths

Examples:
  node breathe.js breathe "I exist in the void"
  node breathe.js perceive 20
    `);
}