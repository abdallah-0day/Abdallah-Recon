#!/bin/bash

domain=$1
output=$2/$1

echo "================================="
echo "[+] Running Abdallah Recon on $domain"
echo "================================="

mkdir -p "$output"

# ----------------------------
# Subdomains
# ----------------------------
echo "[+] Subdomain enumeration..."

subfinder -d $domain -silent > "$output/subfinder.txt"
amass enum -passive -d $domain -silent > "$output/amass.txt"

curl -s "https://crt.sh/?q=%25.$domain&output=json" \
| jq -r '.[].name_value' \
| sed 's/\*\.//g' \
| sort -u > "$output/crt.txt"

cat "$output"/*.txt | sort -u > "$output/subs.txt"

# ----------------------------
# DNS resolve
# ----------------------------
echo "[+] DNS resolving..."

dnsx -l "$output/subs.txt" -silent -o "$output/resolved.txt"

# ----------------------------
# Alive hosts
# ----------------------------
echo "[+] Checking live hosts..."

httpx -l "$output/resolved.txt" -silent -o "$output/alive.txt"

# ----------------------------
# URLs
# ----------------------------
echo "[+] Gathering URLs..."

gau $domain > "$output/gau.txt"
waybackurls $domain > "$output/wayback.txt"

cat "$output/gau.txt" "$output/wayback.txt" | sort -u > "$output/urls.txt"

# ----------------------------
# Parameters
# ----------------------------
echo "[+] Extracting parameters..."

grep "=" "$output/urls.txt" > "$output/params.txt"

# ----------------------------
# JS files
# ----------------------------
echo "[+] Extracting JS files..."

grep "\.js" "$output/urls.txt" | sort -u > "$output/js.txt"

# ----------------------------
# Nuclei scan
# ----------------------------
echo "[+] Running nuclei..."

nuclei -l "$output/alive.txt" -silent -o "$output/nuclei.txt"

echo "[+] Done ✔"
echo "[+] Results saved in $output"
