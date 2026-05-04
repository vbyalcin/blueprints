#!/bin/bash
# Blueprint'ten yeni proje oluşturma scripti
# Kullanım: ./yeni-proje.sh <blueprint-adı> <yeni-proje-klasörü>
# Örnek: ./yeni-proje.sh qr-menu ~/Desktop/menum

set -e

BLUEPRINTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Argüman kontrolü
if [ $# -lt 2 ]; then
  echo "❌ Kullanım: $0 <blueprint-adı> <hedef-klasör>"
  echo ""
  echo "Mevcut blueprintler:"
  for d in "$BLUEPRINTS_DIR"/*/; do
    name=$(basename "$d")
    echo "  - $name"
  done
  exit 1
fi

BLUEPRINT="$1"
TARGET="$2"
SOURCE="$BLUEPRINTS_DIR/$BLUEPRINT"

# Blueprint var mı?
if [ ! -d "$SOURCE" ]; then
  echo "❌ Blueprint bulunamadı: $BLUEPRINT"
  echo ""
  echo "Mevcut blueprintler:"
  ls -1 "$BLUEPRINTS_DIR" | grep -v ".md$\|.sh$"
  exit 1
fi

# CLAUDE.md ve kur.md var mı?
if [ ! -f "$SOURCE/CLAUDE.md" ] || [ ! -f "$SOURCE/kur.md" ]; then
  echo "❌ Blueprint eksik dosya içeriyor (CLAUDE.md veya kur.md yok)"
  exit 1
fi

# Hedef klasörü oluştur
echo "📁 Klasör oluşturuluyor: $TARGET"
mkdir -p "$TARGET"
cd "$TARGET"

# Dosyaları kopyala
echo "📋 Blueprint dosyaları kopyalanıyor..."
cp "$SOURCE/CLAUDE.md" .
mkdir -p .claude/commands
cp "$SOURCE/kur.md" .claude/commands/

# Eğer setup.sh varsa onu da kopyala
if [ -f "$SOURCE/setup.sh" ]; then
  cp "$SOURCE/setup.sh" .
  chmod +x setup.sh
fi

echo ""
echo "✅ Hazır! Sonraki adımlar:"
echo ""
echo "  cd $TARGET"
echo "  claude"
echo "  /kur"
echo ""
echo "Claude Code açılacak, /kur komutunu çalıştır, tek dosya index.html üretecek."
