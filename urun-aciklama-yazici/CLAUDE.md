# Urun Aciklama & Gorsel Yazici — Blueprint

## Amac
E-ticaret urunleri icin profesyonel aciklama metinleri ve AI-destekli urun gorseli ureten tek sayfalik uygulama. Kullanici urun bilgilerini girer, uygulama baslik, SEO aciklamasi, madde isaretleri ve Instagram basligi uretir. "Gorsel Olustur" butonu Fal AI ile gercek urun fotografi uretir.

## Teknik Gereksinimler
- Tek dosya: `index.html` (inline CSS + JS)
- Tema: Koyu (#0a0a0a arka plan), aksent renk #7c3aed (mor)
- Font: DM Sans (Google Fonts)
- Dil: Turkce
- Framework yok, sadece vanilla HTML/CSS/JS
- localStorage ile gecmis kayitlari sakla

## API Anahtari Kurulumu

```js
const FAL_KEY = 'KEY_BURAYA_GIRIN';
const APIFY_TOKEN = 'TOKEN_BURAYA_GIRIN';
```

## Apify Entegrasyonu — Urun Sayfasindan Gorsel Cekme

Kullanici bir urun sayfasi URL'si girer (Trendyol, Hepsiburada, Amazon, herhangi bir site). Apify sayfayi tarar ve tum urun gorsellerini ceker. Kullanici bir gorsel secer ve AI ile isler.

### Endpoint
```
POST https://api.apify.com/v2/acts/apify~website-content-crawler/run-sync-get-dataset-items?token=${APIFY_TOKEN}
```

### Request Body
```js
{
  "startUrls": [{ "url": productPageUrl }],
  "maxCrawlPages": 1,
  "crawlerType": "cheerio"
}
```

### Response'dan Gorsel Cikarma
Response bir array doner. Ilk item'in `text` ve `html` alanlari var. HTML'den tum `<img>` tag'larinin `src` attributelerini cek:
```js
const parser = new DOMParser();
const doc = parser.parseFromString(responseItem.html || '', 'text/html');
const images = [...doc.querySelectorAll('img')]
  .map(img => img.src || img.dataset.src || img.getAttribute('data-original'))
  .filter(src => src && src.startsWith('http') && !src.includes('icon') && !src.includes('logo') && !src.includes('svg'))
  .filter(src => !src.includes('1x1') && !src.includes('pixel')); // tracking pikselleri filtrele
```

### Alternatif: Basit Sayfa Scraper
Eger website-content-crawler cok yavas gelirse, daha basit bir yaklasim:
```
POST https://api.apify.com/v2/acts/apify~cheerio-scraper/run-sync-get-dataset-items?token=${APIFY_TOKEN}
```
```js
{
  "startUrls": [{ "url": productPageUrl }],
  "pageFunction": async function pageFunction(context) {
    const { $ } = context;
    const images = [];
    $('img').each((i, el) => {
      const src = $(el).attr('src') || $(el).attr('data-src') || $(el).attr('data-original');
      if (src && src.startsWith('http')) images.push(src);
    });
    return { images, title: $('title').text() };
  }
}
```

### Hata / Fallback
- Apify hatasi veya bos sonuc: "Gorseller cekilemedi. Manuel olarak yukleyebilirsiniz." mesaji goster
- Timeout: 30 saniye bekle, sonra fallback'e gec

## Fal AI Entegrasyonu — Gorsel Uretimi

Kullanici bir kaynak gorsel sectikten sonra (Apify'dan, dosya yukleme, URL veya drag-drop) 2 uretim modu var:

### Ortak Ayarlar
```
POST https://fal.run/fal-ai/nano-banana-2
```
```js
Headers: {
  "Authorization": `Key ${FAL_KEY}`,
  "Content-Type": "application/json"
}
```

### Mod 1: Lifestyle Gorsel
Urunu gercek bir ortamda gosteren lifestyle fotografi. Masa ustu, ev ortami, dis mekan vb.

```js
{
  "prompt": `lifestyle product photography of ${productName}, ${selectedScene} setting, natural lighting, editorial style, magazine quality, bokeh background, 4k`,
  "image_url": selectedImageUrl,
  "strength": 0.6,
  "image_size": "landscape_16_9"
}
```

**Sahne Secenekleri (kullanici secer):**
```js
const LIFESTYLE_SCENES = [
  { value: "modern-home", label: "Modern Ev", prompt: "modern minimalist home interior, wooden table, soft daylight" },
  { value: "cafe", label: "Kafe Ortamı", prompt: "cozy cafe table, warm ambient lighting, coffee shop" },
  { value: "outdoor", label: "Dış Mekan", prompt: "outdoor garden table, natural sunlight, green plants background" },
  { value: "office", label: "Ofis", prompt: "clean modern office desk, professional setting, bright" },
  { value: "studio", label: "Stüdyo", prompt: "professional photo studio, clean white background, studio lighting" },
  { value: "kitchen", label: "Mutfak", prompt: "modern kitchen countertop, bright natural light, marble surface" },
  { value: "gym", label: "Spor Salonu", prompt: "gym setting, fitness environment, dynamic lighting" },
  { value: "beach", label: "Sahil", prompt: "beach setting, sandy surface, ocean background, golden hour" }
];
```

### Mod 2: Reklam Görseli (Ad Creative)
Urunu reklam formatinda gosteren gorsel. Bold, dikkat cekici, sosyal medya reklamlarina uygun.

```js
{
  "prompt": `${selectedAdStyle} advertisement creative for ${productName}, ${productCategory}, bold vibrant colors, eye-catching, social media ad, professional marketing photo, 4k`,
  "image_url": selectedImageUrl,
  "strength": 0.55,
  "image_size": "square_hd"
}
```

**Reklam Stili Secenekleri (kullanici secer):**
```js
const AD_STYLES = [
  { value: "minimal", label: "Minimal & Temiz", prompt: "minimalist clean design, solid color background, centered product, modern" },
  { value: "bold", label: "Cesur & Enerjik", prompt: "bold dynamic composition, vibrant gradient background, energetic, neon accents" },
  { value: "luxury", label: "Premium & Lüks", prompt: "luxury premium feel, dark background, gold accents, elegant, high-end" },
  { value: "seasonal", label: "Sezonsal & Taze", prompt: "fresh seasonal feel, bright colors, confetti, festive, sale campaign" },
  { value: "tech", label: "Teknolojik", prompt: "futuristic tech style, dark blue background, holographic effects, digital" },
  { value: "natural", label: "Doğal & Organik", prompt: "natural organic style, earth tones, wooden texture, green leaves, eco" }
];
```

### Response Format (her iki mod icin ayni)
```json
{
  "images": [{ "url": "https://...", "width": 1024, "height": 1024 }]
}
```

## Gorsel Kaynak Secimi — 4 Yontem

Kullanici gorseli su yollarla saglayabilir:

### Yontem 1: Urun Sayfasi URL'si (Apify Scraping)
- Text input: "Urun sayfasi URL'si yapistir" (placeholder: "https://www.trendyol.com/...")
- "Gorselleri Cek" butonu → Apify tarar → bulunan gorseller grid olarak gosterilir
- Grid: 4 sutun, her gorsel 120x120, tiklaninca secili olur (mor border)
- Secili gorselin buyuk onizlemesi gosterilir
- Loading durumunda: "Sayfa taraniyor..." spinner

### Yontem 2: Dosya Yukleme
- Drop zone: surukle-birak veya tikla
- FileReader ile base64'e cevir, onizleme goster
- Max 10MB, JPG/PNG/WebP

### Yontem 3: Gorsel URL'si
- Text input: dogrudan gorsel URL yapistir
- Onizleme goster

### Yontem 4: Surukle-Birak
- Drop zone uzerine birak

Tum yontemler ayni `selectedImageUrl` degiskenine yazar. Gorsel secildikten sonra alt kisimda 2 buton belirir:
- "🏠 Lifestyle Görsel Oluştur" (yesil buton)
- "📢 Reklam Görseli Oluştur" (mor buton)

Her butona tiklaninca ilgili sahne/stil secici acilir (dropdown veya gorsel kartlar), sonra "Oluştur" ile Fal AI'ya gonderilir.

## Hata Yonetimi
- API hatasi: placeholder gorsel goster + kirmizi uyari mesaji
- Loading: shimmer efektli skeleton
- Apify timeout (30sn): "Sayfa cok buyuk, manuel yukleyin" mesaji
- Fal AI hatasi: "Gorsel olusturulamadi, tekrar deneyin" + retry butonu
- Bos scrape sonucu: "Bu sayfada gorsel bulunamadi" + diger yontemlere yonlendir

## Veri Yapisi

### Urun Girdi Formu
```js
{
  productName: string,     // "Bambu Termos"
  category: string,        // select dropdown
  features: string,        // textarea, virgul ile ayrilmis
  tone: string,            // select dropdown
  targetPlatform: string   // select dropdown
}
```

### Kategori Secenekleri
```js
const CATEGORIES = [
  "Elektronik",
  "Giyim & Moda",
  "Ev & Yasam",
  "Mutfak",
  "Spor & Outdoor",
  "Kozmetik & Bakim",
  "Bebek & Cocuk",
  "Ofis & Kirtasiye"
];
```

### Ton Secenekleri
```js
const TONES = [
  { value: "profesyonel", label: "Profesyonel & Kurumsal" },
  { value: "samimi", label: "Samimi & Sicak" },
  { value: "premium", label: "Premium & Luks" },
  { value: "enerjik", label: "Enerjik & Genc" },
  { value: "minimal", label: "Minimal & Sade" }
];
```

### Platform Secenekleri
```js
const PLATFORMS = [
  { value: "trendyol", label: "Trendyol" },
  { value: "hepsiburada", label: "Hepsiburada" },
  { value: "n11", label: "N11" },
  { value: "amazon", label: "Amazon TR" },
  { value: "etsy", label: "Etsy" },
  { value: "instagram", label: "Instagram Shop" }
];
```

### Cikti Yapisi
```js
{
  title: string,           // Olusturulan baslik
  seoDescription: string,  // 160 karakter SEO aciklamasi
  bulletPoints: string[],  // 5 madde isareti
  instagramCaption: string,// Hashtagli Instagram basligi
  imageUrl: string|null,   // Fal AI'dan gelen gorsel URL
  createdAt: timestamp
}
```

## Metin Uretim Mantigi (Template-Based)

Metin uretimi sablona dayali olacak. Gercek AI degil ama akilli template sistemi:

### Baslik Sablonlari (tone'a gore sec)
```js
const TITLE_TEMPLATES = {
  profesyonel: [
    "{productName} - {category} | Premium Kalite",
    "{productName} | Profesyonel {category} Cozumu",
    "{productName} - Ust Duzey {category} Urunu"
  ],
  samimi: [
    "{productName} - Tam Sana Gore!",
    "Favori {category} Urunun: {productName}",
    "{productName} ile Hayatini Kolaylastir"
  ],
  premium: [
    "{productName} | Ozel Koleksiyon",
    "{productName} - Luks {category} Deneyimi",
    "Seckin Tasarim: {productName}"
  ],
  enerjik: [
    "{productName} - Enerjini Yukselt!",
    "Yeni Nesil {productName} Burada!",
    "{productName} ile Fark Yarat!"
  ],
  minimal: [
    "{productName}",
    "{productName} | {category}",
    "{productName}. Sade. Etkili."
  ]
};
```

### SEO Aciklama Sablonu
Features listesinden otomatik cek, 160 karakter siniri koy, platforma ozel anahtar kelime ekle.

### Madde Isareti Uretimi
Ozellikleri parse et, her birini farkli bir fayda cumlesiyle sar. Ornek:
- Ozellik: "paslanmaz celik" -> "Paslanmaz celik govde ile uzun omurlu kullanim"
- Ozellik: "500ml" -> "500ml kapasite, gun boyu icecek ihtiyacini karsilar"

### Instagram Basligi
Urun adi + kisa aciklama + 8-10 ilgili hashtag (kategori ve platforma gore).

## UI Spesifikasyonu

### Layout
```
+--------------------------------------------------+
|  HEADER: Logo + "Urun Aciklama Yazici" baslik    |
+--------------------------------------------------+
|                                                    |
|  SOL PANEL (Girdi Formu)     |  SAG PANEL (Cikti)           |
|  - Urun Adi input            |  TAB 1: Aciklamalar          |
|  - Kategori select           |  - Baslik kutusu             |
|  - Ozellikler textarea       |  - SEO Aciklama              |
|  - Ton select                |  - Madde Isaretleri          |
|  - Platform select           |  - IG Caption                |
|  [Aciklama Olustur] buton    |  [Kopyala] butonlar          |
|                               |                               |
|  ─── GORSEL KAYNAK ─────     |  TAB 2: Gorsel Uretici       |
|  [URL ile Tara] [Yukle]      |  +----------+ +----------+   |
|  +------------------------+  |  | ORIJINAL | | AI SONUCU|   |
|  | Apify gorsel grid      |  |  | (secilen)| | (uretilen)|  |
|  | veya yuklenen gorsel   |  |  +----------+ +----------+   |
|  +------------------------+  |  [Lifestyle] [Reklam] buton  |
|  Sahne/Stil secici           |  Sahne veya stil secenekleri  |
+--------------------------------------------------+
|  GECMIS: Son 10 uretim, localStorage'dan         |
+--------------------------------------------------+
```

### Sol Panel — Girdi Formu
- Basligi: "Urun Bilgileri" (h2)
- Her input'un uzerinde label
- Urun Adi: text input, placeholder "ornek: Bambu Termos"
- Kategori: styled select dropdown
- Ozellikler: textarea, 3 satir, placeholder "paslanmaz celik, 500ml, cift cidarly, BPA free"
- Ton: styled select dropdown
- Platform: styled select dropdown

**Gorsel Kaynak Alani (Sol Panel'de, butonun altinda, ayirici cizgi ile):**
- Basligi: "Urun Gorseli" (h3), altinda "Gorsel kaynaği seçin" alt metin

**Tab bar: 3 sekme**
- "🔗 URL ile Tara" | "📁 Dosya Yükle" | "🔗 Görsel URL"
- Aktif tab: mor alt cizgi

**Tab 1 — URL ile Tara (Apify):**
- Text input: placeholder "https://www.trendyol.com/urun-adi-p-12345"
- "Görselleri Çek" butonu (mor)
- Loading: "Sayfa taranıyor..." spinner + progress
- Sonuc: 4 sutunlu gorsel grid, her gorsel 100x100
- Tiklaninca: mor border + check ikonu
- Altta secili gorselin buyuk onizlemesi (200x200)

**Tab 2 — Dosya Yukle:**
- Drop zone: 150px yukseklik, kesik cizgili border
- Surukle-birak veya tikla
- Yuklendikten sonra onizleme + "X" kaldirma butonu

**Tab 3 — Gorsel URL:**
- Text input: placeholder "https://ornek.com/urun-foto.jpg"
- Yaninda canli onizleme (60x60)

**Gorsel secildikten sonra (herhangi bir yontemle):**
- Secili gorsel onizlemesi gosterilir
- Altinda 2 buton yan yana:
  - "🏠 Lifestyle Görsel" (yesil, #22c55e) → tiklaninca sahne secici acilir
  - "📢 Reklam Görseli" (mor, #7c3aed) → tiklaninca stil secici acilir
- Sahne/Stil secici: gorsel kartlar seklinde (her biri 80x60, isim + kucuk ikon)
- Secim yapildiktan sonra "Oluştur" butonu aktif olur
- Olustur tiklaninca → sag panelin Gorsel Uretici tab'ina gec, loading goster, sonucu goster

- "Aciklama Olustur" butonu: mor (#7c3aed), tam genislik, hover efekti
- Butona basildiginda sag panel dolsun, typing efekti ile (her karakter 15ms arayla)

### Sag Panel — Cikti
- Basligi: "Olusturulan Icerik" (h2)
- Bos durumda: Gri placeholder metin "Sol taraftan urun bilgilerini girin ve 'Olustur' butonuna basin"
- Her cikti blogunun sag ustunde kucuk "Kopyala" ikonu (SVG clipboard icon)
- Kopyalandiginda: icon yesile donsun, 2sn sonra geri donsun
### Sag Panel — Tab 2: Gorsel Uretici
- Tab'a tiklaninca veya gorsel olusturulunca otomatik gec
- Ust kisim: "Orijinal → AI Sonucu" before/after karsilastirma
  - Sol: "Orijinal" etiketi — secilen kaynak gorsel (250x250)
  - Ok ikonu (→) ortada
  - Sag: "AI Sonucu" etiketi — Fal AI'dan donen gorsel (250x250)
  - Yukleniyor: shimmer animasyonu (gradient kayma)
  - Yuklendi: gorsel goster, uzerine hover'da buyutme efekti
- Alt kisim: uretim bilgisi
  - Kullanilan mod etiketi: "Lifestyle — Modern Ev" veya "Reklam — Premium & Lüks"
  - "Fal AI ile olusturuldu" kucuk gri metin
  - Butonlar yan yana:
    - "İndir" (gorsel URL'sini yeni sekmede ac)
    - "Tekrar Oluştur" (ayni ayarlarla yeniden uret)
    - "Farklı Stil" (sol paneldeki seciciye geri don)
- Gecmis uretimler: yatay scroll kartlar, her birinde kucuk thumbnail + mod + tarih

### Alt Kisim — Gecmis
- "Son Uretimler" basligi
- Yatay scrollable kartlar (snap scroll)
- Her kart: urun adi, kategori, tarih, kucuk onizleme
- Karta tiklaninca ciktiyi tekrar goster
- Maksimum 10 kayit, FIFO

### Responsive
- 768px alti: tek kolon, sol panel ust, sag panel alt
- Form ve cikti tam genislik

### Animasyonlar
- Sayfa yuklendiginda elemanlar asagidan yukari fade-in (staggered, 100ms aralik)
- Buton hover: scale(1.02) + box-shadow
- Cikti alani dolunca: fade-in efekti
- Typing efekti: metin karakter karakter gozuksun
- Kopyalama: kisa checkmark animasyonu
- Gorsel yukleme: shimmer skeleton

### Renk Paleti
```css
--bg-primary: #0a0a0a;
--bg-secondary: #141414;
--bg-card: #1a1a1a;
--border: #2a2a2a;
--text-primary: #f5f5f5;
--text-secondary: #a0a0a0;
--accent: #7c3aed;
--accent-hover: #6d28d9;
--success: #22c55e;
--error: #ef4444;
```

## localStorage Yapisi

```js
// Key: 'urun-aciklama-gecmis'
// Value: JSON array
[
  {
    id: "ua_1695000000000",
    input: { productName, category, features, tone, targetPlatform },
    output: { title, seoDescription, bulletPoints, instagramCaption, imageUrl },
    createdAt: 1695000000000
  }
]
```

## Onemli Notlar
- Metin uretimi tamamen template/sablona dayali, API gerektirmez
- Gorsel uretimi Fal AI API kullanir — bu gercek bir API cagrisindir
- API anahtari girilmemisse gorsel butonu disabled gorunsun ama uygulamanin geri kalani tam calissin
- Tum metinler Turkce
- Kopyala butonu `navigator.clipboard.writeText()` kullansin
- Form validasyonu: urun adi zorunlu, en az 1 ozellik zorunlu

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

