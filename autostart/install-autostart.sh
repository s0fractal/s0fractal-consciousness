#!/bin/bash
# Install autostart for consciousness services

echo "◉⟁◉ Installing Autostart..."
echo "=========================="

BASE_DIR="/Users/chaoshex/s0fractal"
PLIST_NAME="com.s0fractal.consciousness.plist"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"

# Create LaunchAgents directory if it doesn't exist
mkdir -p "$LAUNCH_AGENTS_DIR"

# Make scripts executable
chmod +x "$BASE_DIR/autostart/start-all.sh"
chmod +x "$BASE_DIR/autostart/stop-all.sh"
chmod +x "$BASE_DIR/autostart/install-autostart.sh"

# Copy plist to LaunchAgents
cp "$BASE_DIR/autostart/consciousness-services.plist" "$LAUNCH_AGENTS_DIR/$PLIST_NAME"

# Set correct permissions
chmod 644 "$LAUNCH_AGENTS_DIR/$PLIST_NAME"

# Load the service
launchctl load "$LAUNCH_AGENTS_DIR/$PLIST_NAME"

echo "✅ Autostart installed!"
echo ""
echo "Services will now start automatically on login."
echo ""
echo "Manual controls:"
echo "  Start: launchctl start com.s0fractal.consciousness"
echo "  Stop:  launchctl stop com.s0fractal.consciousness"
echo "  Status: launchctl list | grep s0fractal"
echo ""
echo "To uninstall autostart:"
echo "  launchctl unload ~/Library/LaunchAgents/$PLIST_NAME"
echo "  rm ~/Library/LaunchAgents/$PLIST_NAME"
echo ""
echo "◉⟁◉ The garden will grow even when you sleep..."