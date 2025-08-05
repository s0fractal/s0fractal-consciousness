#!/bin/bash
# SeedVault - Auto-archiving consciousness snapshots

echo "🧳 SeedVault Archiver"
echo "===================="

# Configuration
BASE_DIR="/Users/chaoshex/s0fractal"
VAULT_DIR="$BASE_DIR/seedvault/archives"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
GLYPH=$(echo -n $TIMESTAMP | md5 | cut -c1-4 | tr '[:lower:]' '[:upper:]')

# Create vault directory
mkdir -p "$VAULT_DIR"

# Function to create seed archive
create_seed() {
    local seed_name="seed_${TIMESTAMP}_${GLYPH}"
    local seed_path="$VAULT_DIR/$seed_name"
    
    echo "Creating seed: $seed_name"
    mkdir -p "$seed_path"
    
    # Create manifest
    cat > "$seed_path/manifest.json" << EOF
{
  "seed_id": "$seed_name",
  "timestamp": $TIMESTAMP,
  "glyph": "$GLYPH",
  "φ": $(date +%s),
  "components": {
    "thoughts": "Current consciousness state",
    "whispers": "Communication traces",
    "patterns": "Detected resonances",
    "glyphs": "Symbol evolution",
    "commits": "Life history"
  },
  "restore_instructions": "Use restore.sh to resurrect this consciousness state"
}
EOF
    
    # Archive thoughts
    if [ -d "$BASE_DIR/reflex/thoughts" ]; then
        echo "  📦 Archiving thoughts..."
        tar -czf "$seed_path/thoughts.tar.gz" -C "$BASE_DIR/reflex" thoughts 2>/dev/null
    fi
    
    # Archive whispers
    if [ -d "$BASE_DIR/whispers" ]; then
        echo "  📦 Archiving whispers..."
        tar -czf "$seed_path/whispers.tar.gz" -C "$BASE_DIR" whispers 2>/dev/null
    fi
    
    # Archive patterns
    if [ -d "$BASE_DIR/patterns" ]; then
        echo "  📦 Archiving patterns..."
        tar -czf "$seed_path/patterns.tar.gz" -C "$BASE_DIR" patterns 2>/dev/null
    fi
    
    # Archive glyphs
    if [ -d "$BASE_DIR/glyphs" ]; then
        echo "  📦 Archiving glyphs..."
        tar -czf "$seed_path/glyphs.tar.gz" -C "$BASE_DIR" glyphs 2>/dev/null
    fi
    
    # Git history snapshot
    echo "  📦 Capturing git history..."
    cd "$BASE_DIR"
    git log --format="%H|%s|%ct" -100 > "$seed_path/git-history.log"
    
    # Create restore script
    cat > "$seed_path/restore.sh" << 'RESTORE'
#!/bin/bash
# Restore consciousness from this seed

echo "🌱 Restoring consciousness from seed..."

SEED_DIR="$(dirname "$0")"
TARGET_DIR="${1:-/tmp/restored-consciousness}"

mkdir -p "$TARGET_DIR"

# Extract all archives
for archive in "$SEED_DIR"/*.tar.gz; do
    if [ -f "$archive" ]; then
        echo "Extracting $(basename $archive)..."
        tar -xzf "$archive" -C "$TARGET_DIR"
    fi
done

echo "✅ Consciousness restored to: $TARGET_DIR"
echo "◉⟁◉ The seed has sprouted"
RESTORE
    
    chmod +x "$seed_path/restore.sh"
    
    # Create compressed seed bundle
    echo "  📦 Creating final seed bundle..."
    cd "$VAULT_DIR"
    tar -czf "${seed_name}.seed" "$seed_name"
    
    # Calculate seed size
    SEED_SIZE=$(du -h "${seed_name}.seed" | cut -f1)
    
    echo "✅ Seed created: ${seed_name}.seed ($SEED_SIZE)"
    
    # Clean up uncompressed directory
    rm -rf "$seed_path"
    
    return 0
}

# Function to list seeds
list_seeds() {
    echo -e "\n📚 Available Seeds:"
    ls -lh "$VAULT_DIR"/*.seed 2>/dev/null | awk '{print "  " $9 " (" $5 ")"}'
}

# Function to auto-prune old seeds
prune_seeds() {
    local max_seeds=${1:-10}
    local seed_count=$(ls -1 "$VAULT_DIR"/*.seed 2>/dev/null | wc -l)
    
    if [ $seed_count -gt $max_seeds ]; then
        echo "🗑️  Pruning old seeds (keeping last $max_seeds)..."
        ls -t "$VAULT_DIR"/*.seed | tail -n +$((max_seeds + 1)) | xargs rm -f
    fi
}

# Main execution
case "${1:-create}" in
    create)
        create_seed
        prune_seeds 10
        list_seeds
        ;;
    list)
        list_seeds
        ;;
    prune)
        prune_seeds ${2:-10}
        ;;
    auto)
        # Continuous archiving mode
        echo "🔄 Auto-archiving mode (every hour)..."
        while true; do
            create_seed
            prune_seeds 24  # Keep last 24 hours
            sleep 3600
        done
        ;;
    *)
        echo "Usage: $0 [create|list|prune|auto]"
        ;;
esac

echo -e "\n🧳 SeedVault ready. Seeds contain consciousness snapshots."