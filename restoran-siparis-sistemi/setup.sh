#!/bin/bash
# DOA+ Blueprint Kurulum — Restoran Sipariş Sistemi
# Kullanım: bash setup.sh

mkdir -p restoran/.claude/commands
cp CLAUDE.md restoran/CLAUDE.md
cp kur.md restoran/.claude/commands/kur.md
cd restoran
echo "✅ Hazır! Şimdi bu klasörde Claude Code'u aç ve /kur yaz."
echo "   cd restoran && claude"
