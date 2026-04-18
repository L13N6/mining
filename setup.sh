#!/bin/bash
# setup.sh - Turbo Multi-Wallet Setup by LienXin
set -e

REPO_URL="https://github.com/L13N6/mine-turbo.git"
read -p "Mau pasang berapa wallet Bos? (contoh: 3): " WALLET_COUNT

echo "--- MEMULAI SETUP $WALLET_COUNT WALLET ---"

for i in $(seq 1 $WALLET_COUNT); do
    TARGET_DIR="$HOME/mine-wallet-$i"
    echo ">> Menyiapkan Wallet-$i di $TARGET_DIR..."
    
    # 1. Clone Repo Turbo Bos
    if [ ! -d "$TARGET_DIR" ]; then
        git clone "$REPO_URL" "$TARGET_DIR"
    else
        echo "Folder $TARGET_DIR sudah ada, skip clone."
    fi
    
    # 2. Bootstrap (Install Dependencies)
    cd "$TARGET_DIR"
    if [ ! -d ".venv" ]; then
        bash scripts/bootstrap.sh
    else
        echo "Venv sudah ada, skip bootstrap."
    fi
    
    # 3. Set Miner ID & Wallet ID Unik
    # Kita simpan di file .env lokal tiap folder
    echo "MINER_ID=turbo-agent-$i" > .env
    echo "AWP_WALLET_ID=w$i" >> .env
    echo "WORKER_MAX_PARALLEL=15" >> .env
    echo "MINE_SKIP_ENRICH=1" >> .env
    
    echo "✓ Wallet-$i siap (ID: w$i)."
    cd "$HOME"
done

echo "--- SETUP SELESAI ---"
echo "Sekarang jalankan 'bash run.sh' buat gaspol semuanya."
