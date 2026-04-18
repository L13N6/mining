#!/bin/bash
# status_multi.sh - Multi-Wallet Status Checker by LienXin
set -e

# Cari semua folder wallet
WALLET_DIRS=$(find "$HOME" -maxdepth 1 -name "mine-wallet-*" -type d | sort)

echo "--- CEK STATUS SEMUA WALLET (TURBO) ---"

for dir in $WALLET_DIRS; do
    echo ">> Checking Status: $(basename $dir)..."
    cd "$dir"
    
    # Check status and epoch progress
    if [ -d ".venv" ]; then
        .venv/bin/python scripts/run_tool.py agent-status || echo "✗ Instance mati atau belum start."
    else
        echo "✗ Instance belum disetup."
    fi
    
    echo "---------------------------------------"
    cd "$HOME"
done

echo "--- CEK SELESAI ---"
