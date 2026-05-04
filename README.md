# Blueprint Kullanım Rehberi

15 hazır uygulama blueprint'i. Her birinde `CLAUDE.md` (detaylı spec) + `kur.md` (build komutu) var.

`/kur` komutu çalıştığında Claude Code, CLAUDE.md'yi okur ve **tek dosya index.html** olarak çalışan uygulamayı üretir.

---

## ⚡ Hızlı Başlangıç (en kolay yol)

```bash
# Tek script ile yeni proje oluştur
~/goathq/webinar-ozel/blueprints/yeni-proje.sh <blueprint-adı> <hedef-klasör>
```

**Örnek:**
```bash
~/goathq/webinar-ozel/blueprints/yeni-proje.sh qr-menu ~/Desktop/menum
cd ~/Desktop/menum
claude
# /kur yaz
```

3-5 dakika sonra `index.html` hazır, browser'da açılır.

---

## 📋 Manuel kurulum (script çalışmazsa)

```bash
# 1. Yeni klasör
mkdir ~/Desktop/proje-adi && cd ~/Desktop/proje-adi

# 2. Blueprint dosyalarını kopyala (DOĞRU YOLLAR)
cp ~/goathq/webinar-ozel/blueprints/qr-menu/CLAUDE.md .
mkdir -p .claude/commands
cp ~/goathq/webinar-ozel/blueprints/qr-menu/kur.md .claude/commands/

# 3. Claude Code aç
claude

# 4. Çalıştır
/kur
```

---

## 🗂️ 15 Blueprint

### E-TİCARET (4)

**1. urun-aciklama-yazici** — Ürün açıklama + Fal AI ile gerçek ürün fotoğrafı
```bash
~/goathq/webinar-ozel/blueprints/yeni-proje.sh urun-aciklama-yazici ~/Desktop/urun-yazici
```

**2. stok-dashboard** — Envanter yönetim paneli, 20 ürün hazır, CSV export
```bash
~/goathq/webinar-ozel/blueprints/yeni-proje.sh stok-dashboard ~/Desktop/stok
```

**3. fiyat-hesaplayici** — Apify ile Google Shopping'den rakip fiyat
```bash
~/goathq/webinar-ozel/blueprints/yeni-proje.sh fiyat-hesaplayici ~/Desktop/fiyat
```

**4. qr-menu** — Restoran QR menü + Fal AI yemek fotoğrafları
```bash
~/goathq/webinar-ozel/blueprints/yeni-proje.sh qr-menu ~/Desktop/menum
```

---

### YOUTUBE (3)

**5. video-icerik-uretici** — Başlık/tag/script + Fal AI thumbnail
```bash
~/goathq/webinar-ozel/blueprints/yeni-proje.sh video-icerik-uretici ~/Desktop/yt-icerik
```

**6. thumbnail-olusturucu** — Canvas editör + AI arka plan
```bash
~/goathq/webinar-ozel/blueprints/yeni-proje.sh thumbnail-olusturucu ~/Desktop/thumbnail
```

**7. analytics-dashboard** — Apify ile gerçek YouTube kanal verisi
```bash
~/goathq/webinar-ozel/blueprints/yeni-proje.sh analytics-dashboard ~/Desktop/yt-analytics
```

---

### OTOMASYON (3)

**8. workflow-builder** — n8n tarzı görsel akış oluşturucu
```bash
~/goathq/webinar-ozel/blueprints/yeni-proje.sh workflow-builder ~/Desktop/workflow
```

**9. lead-scraper-panel** — Apify ile Google Maps'ten lead scraping
```bash
~/goathq/webinar-ozel/blueprints/yeni-proje.sh lead-scraper-panel ~/Desktop/lead-scraper
```

**10. email-kampanya-yoneticisi** — Cold email funnel yönetimi
```bash
~/goathq/webinar-ozel/blueprints/yeni-proje.sh email-kampanya-yoneticisi ~/Desktop/email-kampanya
```

---

### UYGULAMALAR (3)

**11. randevu-sistemi** — Takvim + booking sistemi
```bash
~/goathq/webinar-ozel/blueprints/yeni-proje.sh randevu-sistemi ~/Desktop/randevu
```

**12. fatura-olusturucu** — KDV + canlı önizleme + PDF
```bash
~/goathq/webinar-ozel/blueprints/yeni-proje.sh fatura-olusturucu ~/Desktop/fatura
```

**13. restoran-siparis-sistemi** — 3 ekran (menu/mutfak/yönetim), gerçek zamanlı
```bash
~/goathq/webinar-ozel/blueprints/yeni-proje.sh restoran-siparis-sistemi ~/Desktop/restoran
```

---

### DİĞER (2)

**14. portfolio-site-builder** — Görsel portfolio + Fal AI profil foto
```bash
~/goathq/webinar-ozel/blueprints/yeni-proje.sh portfolio-site-builder ~/Desktop/portfolio
```

**15. ai-chatbot-widget** — Chatbot widget + AI bot avatarı
```bash
~/goathq/webinar-ozel/blueprints/yeni-proje.sh ai-chatbot-widget ~/Desktop/chatbot
```

---

## 🔑 API Anahtarları (gerekli olanlar için)

Bazı blueprintler API kullanıyor. CLAUDE.md içinde anahtarın koyulacağı yer belirtiliyor.

**Fal AI:** https://fal.ai/dashboard/keys
**Apify:** https://console.apify.com/account/integrations

API anahtarı koyulmazsa o özellikler çalışmaz ama uygulamanın geri kalanı çalışır.

---

## 🎬 Webinar Demo Akışı

```bash
# 1. Webinar'da göster
~/goathq/webinar-ozel/blueprints/yeni-proje.sh qr-menu ~/Desktop/canli-demo

# 2. Klasöre git
cd ~/Desktop/canli-demo

# 3. Claude Code aç
claude

# 4. Çalıştır
/kur

# 5. 3-5 dakika sonra browser'da açılır
# Sen demo yaparken katılımcılar paralel olarak kendi blueprint'ini deniyor
```

---

## 🚀 Hızlı Referans Tablosu

| # | Blueprint | API | Wow Faktörü |
|---|-----------|-----|-------------|
| 1 | Ürün Açıklama Yazıcı | Fal AI | Gerçek ürün fotoğrafı üretiyor |
| 2 | Stok Dashboard | — | Tam çalışan envanter |
| 3 | Fiyat Hesaplayıcı | Apify | Google Shopping rakip fiyat |
| 4 | QR Menü | Fal AI | AI yemek fotoğrafları |
| 5 | Video İçerik Üretici | Fal AI | AI thumbnail |
| 6 | Thumbnail Tasarımcı | Fal AI | AI arka plan + canvas |
| 7 | YouTube Analytics | Apify | Gerçek kanal verisi |
| 8 | Workflow Builder | — | n8n tarzı görsel akış |
| 9 | Lead Scraper | Apify | Google Maps'ten lead |
| 10 | Email Kampanya | — | Cold email funnel |
| 11 | Randevu Sistemi | — | Takvim + booking |
| 12 | Fatura Oluşturucu | — | Canlı önizleme + PDF |
| 13 | Restoran Sistemi | — | 3 ekran gerçek zamanlı |
| 14 | Portfolio Builder | Fal AI | AI profil + proje görseli |
| 15 | Chatbot Widget | Fal AI | AI bot avatarı |

---

## ❓ Sorun giderme

**"yeni-proje.sh: Permission denied":**
```bash
chmod +x ~/goathq/webinar-ozel/blueprints/yeni-proje.sh
```

**"Blueprint bulunamadı":**
- Blueprint adını yanlış yazmışsın, `ls ~/goathq/webinar-ozel/blueprints/` ile kontrol et

**"/kur komutu çalışmıyor":**
- `.claude/commands/kur.md` doğru yerde mi? `ls -la .claude/commands/`
- Claude Code'u yeniden başlat (`exit` → `claude`)

**API çalışmıyor:**
- CLAUDE.md'deki `FAL_KEY` veya `APIFY_TOKEN` placeholder'ını kendi anahtarınla değiştir
- Free tier limitlerine takıldıysan dashboard'tan kontrol et

**index.html oluştu ama tarayıcıda açmıyor:**
```bash
open index.html
# ya da
python3 -m http.server 8000
# ardından http://localhost:8000
```
