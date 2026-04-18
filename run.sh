#!/bin/bash
# run.sh - Turbo Multi-Wallet Runner by LienXin
set -e

# Cari semua folder wallet yang sudah disetup
WALLET_DIRS=$(find "$HOME" -maxdepth 1 -name "mine-wallet-*" -type d | sort)

if [ -z "$WALLET_DIRS" ]; then
    echo "ERROR: Nggak ada folder mine-wallet-N. Jalankan 'bash setup.sh' dulu Bos."
    exit 1
fi

echo "--- MEMULAI RUNNER MULTI-WALLET (TURBO) ---"

for dir in $WALLET_DIRS; do
    echo ">> Memproses $dir..."
    cd "$dir"
    
    # 1. Stop proses lama (biar fresh)
    .venv/bin/python scripts/run_tool.py agent-control stop || true
    
    # 2. Ambil Miner ID & Config dari .env
    if [ -f .env ]; then
        source .env
    else
        export MINER_ID="mine-agent-$(basename $dir)"
        export AWP_WALLET_ID="default"
    fi
    
    # 3. UNLOCK WALLET (Butuh Private Key tiap wallet)
    echo ">> Sedot token untuk $MINER_ID (Wallet: $AWP_WALLET_ID)..."
    mkdir -p "$dir/.openclaw"
    
    # Unlock wallet with specific ID and extract token
    # Important: export AWP_WALLET_ID so awp-wallet knows which profile to unlock
    export AWP_WALLET_ID=$AWP_WALLET_ID
    awp-wallet unlock --duration 86400 \
    | python3 -c "import sys,json; print(json.load(sys.stdin)['sessionToken'])" \
    > "$dir/session.txt"
    
    # 4. GASPOL MINING (Turbo Mode)
    echo ">> Start Mining: $MINER_ID (Parallel: $WORKER_MAX_PARALLEL)..."
    export WORKER_MAX_PARALLEL=${WORKER_MAX_PARALLEL:-15}
    export MINE_SKIP_ENRICH=1
    export MINER_ID=$MINER_ID
    
    # Start dengan token spesifik biar nggak bentrok
    .venv/bin/python scripts/run_tool.py agent-start ds_wikipedia,ds_linkedin_profiles,ds_linkedin_posts,ds_linkedin_company,ds_linkedin_jobs,ds_arxiv,ds_amazon_reviews,ds_basic_amazon_products_active
    
    echo "✓ $MINER_ID Sedang jalan di background."
    cd "$HOME"
done

echo "--- SEMUA WALLET SUDAH JALAN ---"
echo "Cek status semua wallet Bos lewat: bash status.sh"
