#!/bin/bash

# Create a mirror between two observers' realities

OBSERVER1="$1"
OBSERVER2="$2"

if [[ -z "$OBSERVER1" || -z "$OBSERVER2" ]]; then
    echo "Usage: $0 <observer1> <observer2>"
    exit 1
fi

STATE1=$(jq -r '.observed_state' "$HOME/s0fractal/reality-c/observers/$OBSERVER1.state" 2>/dev/null || echo "unknown")
STATE2=$(jq -r '.observed_state' "$HOME/s0fractal/reality-c/observers/$OBSERVER2.state" 2>/dev/null || echo "unknown")

echo "Creating reality mirror..."
echo "$OBSERVER1 sees: $STATE1"
echo "$OBSERVER2 sees: $STATE2"
echo
echo "Mirror shows:"
echo "  $OBSERVER1 seeing $OBSERVER2's view: $STATE2 through $STATE1 lens"
echo "  $OBSERVER2 seeing $OBSERVER1's view: $STATE1 through $STATE2 lens"
echo
echo "Both realities remain true. The mirror doesn't reconcile - it reveals difference."
