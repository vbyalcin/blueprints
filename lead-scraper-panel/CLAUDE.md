# Lead Scraping Kontrol Paneli

## Genel Bakis
Apify API entegrasyonlu gercek lead scraping paneli. Kullanici Google Maps uzerinden isletme verisi ceker, tabloda gorur, CSV olarak indirir. Fallback olarak 25+ onceden doldurulmus Turkce firma verisi icerir.

## Teknik Gereksinimler
- **Tek dosya:** `index.html` (inline CSS + JS)
- **Font:** DM Sans (Google Fonts)
- **Tema:** Koyu (#0a0a0a arka plan), aksent renk #10b981 (yesil)
- **Dil:** Turkce
- **Framework:** Yok — vanilla HTML/CSS/JS
- **API:** Apify (Google Places scraper)

## API Entegrasyonu

### Apify — Google Maps Scraper
```javascript
const APIFY_TOKEN = 'TOKEN_BURAYA_GIRIN';

async function scrapeGoogleMaps(query, location = 'istanbul') {
  const response = await fetch(
    `https://api.apify.com/v2/acts/compass~crawler-google-places/run-sync-get-dataset-items?token=${APIFY_TOKEN}`,
    {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        searchStringsArray: [`${query} ${location}`],
        maxCrawledPlacesPerSearch: 10,
        language: 'tr'
      })
    }
  );
  const data = await response.json();
  return data; // [{title, address, phone, website, totalScore, categoryName, ...}]
}
```

API cevabindan su alanlari kullan:
- `title` → Firma Adi
- `address` → Adres
- `phone` → Telefon
- `website` → Web Sitesi
- `totalScore` → Puan
- `categoryName` → Kategori
- `url` → Google Maps Linki

API anahtari girilmemisse veya istek basarisiz olursa fallback verileri goster ve kullaniciya bilgi ver.

## Sayfa Yapisi

### Header
- Sol: "Lead Scraper" baslik + "Kontrol Paneli" alt baslik
- Sag: "Yeni Tarama Baslat" butonu (#10b981, buyuk), "CSV Indir" butonu (outline)

### Istatistik Kartlari (4 kart, tek satir)
1. **Toplam Lead** — rakam + grafik ikonu (ornek: 847)
2. **Email Bulunan** — rakam (ornek: 623)
3. **Gecerli** — rakam + yuzde (ornek: 541 / %87)
4. **Kampanya Gonderilen** — rakam (ornek: 312)

Her kart: koyu arka plan (#141414), sol kenarda aksent renk border, buyuk rakam + kucuk etiket + degisim yuzdesi (yesil yukari ok veya kirmizi asagi ok)

### Yeni Tarama Modal
"Yeni Tarama Baslat" butonuna tiklandiginda overlay modal:
- Baslik: "Yeni Tarama Olustur"
- **Kaynak secimi:** Radio butonlar
  - Google Maps (varsayilan, aktif)
  - LinkedIn (yakin zamanda, disabled)
  - Web Sitesi (yakin zamanda, disabled)
- **Arama sorgusu:** Text input — placeholder "ornegin: dis klinigi, avukat, restoran..."
- **Konum:** Text input — varsayilan "istanbul", placeholder "sehir adi"
- **Maksimum sonuc:** Dropdown — 10, 25, 50, 100
- "Taramayi Baslat" butonu
- Tarama basladiginda:
  - Modal kapanir
  - Header altinda ilerleme cubugu gorulur (animated gradient)
  - Sayac animasyonu: "Taraniyor... 3/10 isletme bulundu" (her 500ms artar)
  - API cevabi geldiginde tablo guncellenir
  - Basari toast mesaji: "12 yeni lead eklendi!"

### Lead Tablosu
Tam genislik tablo:
- Sutunlar: Checkbox | Firma Adi | Kategori | Telefon | Web Sitesi | Puan | Konum | Kaynak | Tarih | Islemler
- Her satir hover'da aydinlanir (#1a1a1a)
- Puan: Yildiz ikonu ile (5 uzerinden)
- Web sitesi: tiklanabilir link (yeni sekmede acilir)
- Kaynak: badge (Google Maps = mavi, LinkedIn = acik mavi, Manuel = gri)
- Islemler: Duzenle (kalem ikonu), Sil (cop ikonu)
- Checkbox ile toplu secim, ust satir "Tumunu Sec"
- Tablo altinda sayfalama: "1-25 / 47 sonuc", Onceki/Sonraki butonlar

### On Yuklu Fallback Veriler (25+ kayit)
Gercekci Turkce firma verileri:
```
1. Beyoglu Dis Klinigi | Dis Klinigi | +90 212 555 0101 | beyogludis.com | 4.7 | Beyoglu, Istanbul
2. Atlas Hukuk Burosu | Avukat | +90 212 555 0202 | atlashukuk.com.tr | 4.5 | Sisli, Istanbul
3. Marmara Yazilim A.S. | Yazilim | +90 216 555 0303 | marmarayazilim.com | 4.8 | Kadikoy, Istanbul
4. Bogazici Muhasebe | Muhasebe | +90 212 555 0404 | bogazicimuhasebe.com | 4.3 | Besiktas, Istanbul
5. Anadolu Lojistik | Lojistik | +90 216 555 0505 | anadolulojistik.com | 4.6 | Umraniye, Istanbul
6. Istanbul Gayrimenkul | Emlak | +90 212 555 0606 | istanbulgayrimenkul.com | 4.4 | Levent, Istanbul
7. Deniz Sigorta | Sigorta | +90 212 555 0707 | denizsigorta.com.tr | 4.2 | Mecidiyekoy, Istanbul
8. Yildiz Danismanlik | Danismanlik | +90 216 555 0808 | yildizdanismanlik.com | 4.9 | Atasehir, Istanbul
9. Karadeniz Gida A.S. | Gida | +90 212 555 0909 | karadenizgida.com | 4.1 | Bayrampasa, Istanbul
10. Ege Tekstil | Tekstil | +90 232 555 1010 | egetekstil.com | 4.5 | Konak, Izmir
11. Akdeniz Turizm | Turizm | +90 242 555 1111 | akdenizturizm.com | 4.7 | Muratpasa, Antalya
12. Trakya Otomasyon | Otomasyon | +90 284 555 1212 | trakyaotomasyon.com | 4.6 | Edirne
13. Baskent Insaat | Insaat | +90 312 555 1313 | baskentinsaat.com.tr | 4.3 | Cankaya, Ankara
14. Olimpos Spor Merkezi | Spor | +90 216 555 1414 | olimposspor.com | 4.8 | Maltepe, Istanbul
15. Cankaya Veteriner | Veteriner | +90 312 555 1515 | cankayavet.com | 4.4 | Cankaya, Ankara
16. Galata Restoran | Restoran | +90 212 555 1616 | galatarestoran.com | 4.6 | Karakoy, Istanbul
17. Pendik Eczanesi | Eczane | +90 216 555 1717 | pendikeczane.com | 4.2 | Pendik, Istanbul
18. Kuzey Enerji | Enerji | +90 462 555 1818 | kuzeyenerji.com | 4.5 | Trabzon
19. Bati Medikal | Medikal | +90 224 555 1919 | batimedikal.com | 4.7 | Bursa
20. Guney Tarim | Tarim | +90 322 555 2020 | guneytarim.com | 4.3 | Adana
21. Doruk Egitim | Egitim | +90 212 555 2121 | dorukegitim.com | 4.9 | Bakirkoy, Istanbul
22. Merkez Optik | Optik | +90 212 555 2222 | merkezoptik.com | 4.4 | Fatih, Istanbul
23. Sehir Kargo | Kargo | +90 216 555 2323 | sehirkargo.com | 4.1 | Kartal, Istanbul
24. Asya Mobilya | Mobilya | +90 262 555 2424 | asyamobilya.com | 4.6 | Kocaeli
25. Avrupa Oto Servis | Oto Servis | +90 212 555 2525 | avrupaoto.com | 4.5 | Bagilar, Istanbul
```

Her kayda rastgele tarih ata (son 30 gun icinde) ve kaynak olarak karisik dagit.

### Filtre Cubugu (tablo ustunde)
- Kaynak filtresi: dropdown (Tumunu, Google Maps, LinkedIn, Manuel)
- Kategori filtresi: dropdown (tum benzersiz kategoriler)
- Puan filtresi: minimum puan slider veya dropdown (3+, 4+, 4.5+)
- Arama: text input ile firma adi arama

### CSV Indirme
"CSV Indir" butonuna tiklandiginda:
- Filtreli verileri CSV formatinda indir
- Dosya adi: `leadler_YYYY-MM-DD.csv`
- BOM karakteri ekle (Excel Turkce uyumlulugu icin)
- Gercek dosya indirme (Blob + download link)

## Stil Detaylari
```
Arka plan: #0a0a0a
Kart arka plan: #141414
Tablo satirlari: #111111 / #0e0e0e (zebra)
Hover: #1a1a1a
Border: #222222
Aksent: #10b981
Aksent hover: #34d399
Yazi: #e5e5e5
Ikincil yazi: #888888
Basari: #10b981
Uyari: #f59e0b
Hata: #ef4444
```

## Responsive
- 1024px+: Tam layout
- 768-1024px: Tablo yatay scroll
- Mobil: Kartlar tek sutun, tablo yatay scroll

---

## 🎯 3 GÖRÜNÜM ZORUNLULUĞU (ÖNEMLİ)

Bu uygulamayı kurarken **3 farklı view (görünüm)** zorunlu olarak içerecek. Sağ panelde tab'lar ile geçiş:

### View 1: 📱 Düzenleyici / Editör (varsayılan)
- Yukarıda anlatılan ana editör arayüzü
- Sol panel form/ayarlar, sağ panel mini önizleme

### View 2: 🌐 Web Sitesi / Landing Page
- Browser frame (mac-stili: 3 colored dots + URL bar)
- Tam müşteri-yüzlü landing page mockup:
  - **Hero** — büyük başlık, slogan, 2 CTA buton, gradient arka plan
  - **3 Feature** kartı (icon + başlık + açıklama)
  - **Popüler içerik grid** (varsa popular işaretli olanlar otomatik)
  - **İletişim Info** (adres, saat, telefon — 3 kolon)
  - **CTA section** — büyük çağrı + buton
  - **Footer** — copyright + brand

### View 3: 🍽️ Müşteri Görünümü / Tam UI
- Browser frame
- Müşterinin gerçekten kullanacağı tam ekran arayüz
- (Bu uygulamanın asıl ürünü — örn QR menü için tam menü sayfası, randevu için booking sayfası)

### Tab Sistemi (zorunlu)
```html
<div class="view-tabs">
  <button class="view-tab active" onclick="switchView('phone')">📱 Editör</button>
  <button class="view-tab" onclick="switchView('landing')">🌐 Web Sitesi</button>
  <button class="view-tab" onclick="switchView('app')">🎯 Tam UI</button>
</div>
```

### Browser Frame CSS (zorunlu)
```css
.browser-frame {
  background: white; border-radius: 12px; overflow: hidden;
  box-shadow: 0 20px 60px rgba(0,0,0,0.4); border: 1px solid #333;
}
.browser-bar {
  background: #2a2a2a; padding: 10px 16px;
  display: flex; align-items: center; gap: 16px;
}
.browser-dots span { width: 12px; height: 12px; border-radius: 50%; }
.browser-dots span:nth-child(1) { background: #ff5f57; }
.browser-dots span:nth-child(2) { background: #febc2e; }
.browser-dots span:nth-child(3) { background: #28c840; }
.browser-url {
  background: #1a1a1a; color: #999; padding: 6px 14px;
  border-radius: 6px; font-size: 12px; flex: 1; text-align: center;
}
```

### Reactive Updates
Her view aynı state'ten render edilmeli — editör'deki değişiklik anında 3 view'da yansımalı.

```js
function switchView(view) {
  currentView = view;
  document.querySelectorAll('.view-tab').forEach(t => t.classList.toggle('active', t.dataset.view === view));
  document.querySelectorAll('.view-content').forEach(c => c.classList.add('hidden'));
  document.getElementById('view-' + view).classList.remove('hidden');
  if (view === 'landing') renderLanding();
  if (view === 'app') renderApp();
  if (view === 'phone') renderPreview();
}
```

### Landing Page İçerik Üretimi
Müşteri sektörüne göre AI ile üretilebilir ya da template'le:
- Restoran → "Geleneksel Lezzet, Modern Sunuş" + 3 değer önermesi
- Diş kliniği → "Profesyonel Diş Hizmeti" + uzmanlık alanları
- Salon → "Modern Saç & Güzellik" + hizmetler
- Otel → "Konfor + Lüks" + oda tipleri

### Tab Arası Geçiş Animasyonu (opsiyonel)
Smooth opacity transition (0.2s).

