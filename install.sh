#!/bin/bash

echo "================================="
echo "[+] Installing Abdallah-Recon"
echo "================================="

# Tools check
tools=(subfinder amass httpx dnsx gau waybackurls jq nuclei)

for t in "${tools[@]}"; do
    if ! command -v $t &> /dev/null; then
        echo "[-] Missing tool: $t"
        echo "[!] Install it first then rerun"
        exit 1
    fi
done

# Permissions
chmod +x abdallah-recon core.sh

# Move to system path
sudo cp abdallah-recon /usr/local/bin/abdallah-recon

echo "[+] Installed successfully ✔"
echo "[+] Run: abdallah-recon -d example.com -o output"
