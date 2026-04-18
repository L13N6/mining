#!/bin/bash
# clean_vps.sh - Cleanup script for Bos L13N6
# Focuses on clearing cache and logs without touching wallet/scripts.

echo "--- VPS CLEANUP (SPACE SAVER) ---"

# 1. NPM Cache
if [ -d "$HOME/.npm" ]; then
    echo ">> Clearing NPM Cache..."
    rm -rf "$HOME/.npm"
fi

# 2. General Cache
if [ -d "$HOME/.cache" ]; then
    echo ">> Clearing General Cache..."
    rm -rf "$HOME/.cache"
fi

# 3. Crawl4AI Cache (Often huge)
if [ -d "$HOME/.crawl4ai/cache" ]; then
    echo ">> Clearing Crawl4AI Cache..."
    rm -rf "$HOME/.crawl4ai/cache"
fi

# 4. OpenClaw Logs
if [ -d "$HOME/.openclaw/logs" ]; then
    echo ">> Clearing OpenClaw Logs..."
    rm -rf "$HOME/.openclaw/logs/*"
fi

# 5. Mining Output (Logs/Artifacts)
# Note: Ini bisa dihapus kalau Bos gak butuh history per-item
echo ">> Clearing Mining Output (Agent Runs)..."
find "$HOME" -name "agent-runs" -type d -exec rm -rf {}/* \; 2>/dev/null || true

# 6. Python Pycache
echo ">> Clearing Python Pycache..."
find "$HOME" -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true

echo "--- CLEANUP SELESAI ---"
df -h "$HOME"
