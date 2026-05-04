# YouTube Analytics Dashboard

Bu proje bir YouTube kanal analiz panosu. Tek bir `index.html` dosyası olarak kur — tüm CSS ve JS inline olacak. Harici kütüphane veya framework KULLANMA.

## Genel Bakış

Kullanıcı bir YouTube kanal URL'si girer, **Apify** ile gerçek kanal verileri çekilir ve dashboard'da gösterilir:
- Abone sayısı, toplam görüntülenme, video sayısı
- Son videolar tablosu (başlık, görüntülenme, tarih)
- SVG ile görüntülenme trendi grafiği
- En iyi videolar sıralaması
- Zaman dilimi seçici (7/30/90 gün)
- Animasyonlu sayaçlar
- API başarısız olursa önceden tanımlı mock verilerle çalışır

## Tasarım

- **Tema:** Koyu (#0a0a0a arka plan)
- **Font:** DM Sans (Google Fonts'tan yükle)
- **Accent:** YouTube kırmızı (#ff0000)
- **Secondary accent:** #cc0000
- **Kartlar:** #141414 arka plan, 1px solid rgba(255,255,255,0.08) border
- **Border radius:** 12px
- **Stat kartları:** Üstte 4'lü grid, her birinde ikon, sayı (büyük), etiket (küçük)
- **Tablo:** #141414 bg, satır hover #1a1a1a, header #111
- **Grafik:** SVG, #ff0000 çizgi, #ff000020 alan dolgusu
- **Responsive:** Mobilde tek kolon, tablo yatay scroll

## Sayfa Yapısı

### Header
- "📊 YouTube Analytics" başlık (h1)
- Alt başlık: "Kanal performansınızı analiz edin"
- Sağ üstte YouTube ikonu (inline SVG)

### Kanal Arama Bölümü
- Geniş arama çubuğu (tam genişlik, ortalanmış, max-width: 600px)
- Placeholder: "YouTube kanal URL'sini yapıştır... Örn: https://youtube.com/@kanaladi"
- Sağında "Verileri Çek" butonu (accent renk)
- Loading durumu: buton disabled, spinner animasyonu, "Veriler çekiliyor..." yazısı
- Altında küçük yazı: "veya örnek verilerle incele" linki (mock data yükler)

### API Entegrasyonu — Apify

```javascript
const APIFY_TOKEN = 'TOKEN_BURAYA_GIRIN';

async function fetchChannelData(channelUrl) {
  const response = await fetch(
    `https://api.apify.com/v2/acts/streamers~youtube-channel-scraper/run-sync-get-dataset-items?token=${APIFY_TOKEN}`,
    {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        channelUrls: [channelUrl],
        maxResults: 30,
        sortBy: 'date'
      })
    }
  );

  if (!response.ok) throw new Error('API hatası');
  const data = await response.json();
  if (!data || data.length === 0) throw new Error('Kanal bulunamadı');
  return data;
}
```

- API yanıtından çıkarılacak veriler: kanal adı, abone sayısı, toplam görüntülenme, video listesi (başlık, görüntülenme, yayın tarihi, beğeni, yorum sayısı)
- API'den dönen veri yapısını normalize et — eksik alanlar için fallback değerler koy
- **Timeout:** 60 saniye (Apify sync çağrıları uzun sürebilir)
- Hata durumunda: kırmızı uyarı banner + "Mock verilerle devam et" butonu

### Zaman Dilimi Seçici
- 3 butonlu segmented control: "7 Gün" | "30 Gün" | "90 Gün"
- Seçime göre grafik ve tablo filtrelenir
- Varsayılan: 30 Gün
- Pozisyon: stat kartlarının üstünde, sağa yasalı

### Stat Kartları — 4'lü Grid

```
[Abone Sayısı] [Toplam Görüntülenme] [Video Sayısı] [Ort. Görüntülenme]
```

Her kart:
- Üstte ikon (inline SVG veya emoji): 👥 👁️ 🎬 📈
- Ortada büyük sayı (animasyonlu counter, 0'dan hedefe 1.5 saniyede)
- Altta etiket ve değişim yüzdesi (yeşil ↑ veya kırmızı ↓)
- Hover'da hafif scale(1.02) ve gölge artışı

**Animasyonlu Counter:**
```javascript
function animateCounter(element, target, duration = 1500) {
  const start = 0;
  const startTime = performance.now();

  function update(currentTime) {
    const elapsed = currentTime - startTime;
    const progress = Math.min(elapsed / duration, 1);
    // easeOutExpo
    const eased = 1 - Math.pow(2, -10 * progress);
    const current = Math.floor(start + (target - start) * eased);
    element.textContent = formatNumber(current);
    if (progress < 1) requestAnimationFrame(update);
  }

  requestAnimationFrame(update);
}

function formatNumber(num) {
  if (num >= 1000000) return (num / 1000000).toFixed(1) + 'M';
  if (num >= 1000) return (num / 1000).toFixed(1) + 'K';
  return num.toLocaleString('tr-TR');
}
```

### Görüntülenme Trendi Grafiği (SVG)

- SVG elementi, tam genişlik, 300px yükseklik
- Kart içinde: başlık "Görüntülenme Trendi", sağda zaman dilimi bilgisi
- X ekseni: tarihler (son N gün, seçime göre)
- Y ekseni: görüntülenme sayıları (otomatik ölçekleme)
- Çizgi grafiği: `<polyline>` ile, #ff0000 stroke (2px)
- Alan dolgusu: `<polygon>` ile, gradient (üstte #ff000040, altta transparent)
- Hover efekti: nokta üzerine gelince tooltip (tarih + görüntülenme)
- Grid çizgileri: yatay, rgba(255,255,255,0.05)
- Eksen etiketleri: beyaz, 11px, opaklık 0.5

**SVG Tooltip:**
- Her veri noktasında görünmez circle (r=15, hover alanı)
- Hover'da: küçük tooltip kutusu (SVG `<rect>` + `<text>`)
- Tooltip içeriği: "15 Mar: 45.2K görüntülenme"

### Son Videolar Tablosu

- Kart içinde: başlık "Son Videolar"
- Tablo sütunları: #, Başlık, Görüntülenme, Beğeni, Yorum, Tarih
- Satır hover efekti (#1a1a1a)
- Görüntülenme sayısına göre küçük bar göstergesi (satır içi, max genişlik 100px)
- Tarih formatı: "15 Mar 2026"
- Maksimum 20 satır
- Sıralama: varsayılan tarihe göre (yeniden eskiye), sütun başlığına tıklayarak değiştir

### En İyi Videolar — Yatay Kart Grid

- Başlık: "En Çok İzlenen Videolar"
- 3 kart yan yana (mobilde dikey), her biri:
  - Sıra numarası (büyük, #ff0000 renk)
  - Video başlığı (bold, 2 satırda truncate)
  - Görüntülenme sayısı
  - Beğeni oranı (beğeni / görüntülenme yüzdesi)
  - Yayın tarihi

### Demografik Tahmini (Mock) — İkincil Bölüm

- Başlık: "Tahmini Kitle Dağılımı" (küçük "tahmin" etiketi)
- SVG yatay bar chart:
  - Yaş grupları: 13-17, 18-24, 25-34, 35-44, 45-54, 55+
  - Her bar: label, yüzde, yatay bar
  - Renkler: farklı opaklıklarda kırmızı (#ff0000 %100 → %30)
- Bu tamamen mock veri — API'den gelmiyor, rastgele ama gerçekçi dağılım

## Mock Veri (Fallback)

API başarısız olduğunda veya "örnek verilerle incele" tıklandığında:

```javascript
const mockData = {
  channelName: 'Örnek Kanal',
  subscriberCount: 12400,
  totalViews: 1243567,
  videoCount: 87,
  videos: [
    {
      title: 'Python ile Otomasyon: Başlangıç Rehberi',
      views: 45200,
      likes: 1850,
      comments: 234,
      date: '2026-03-20'
    },
    {
      title: 'No-Code ile SaaS Kurma — Adım Adım',
      views: 38700,
      likes: 1620,
      comments: 189,
      date: '2026-03-15'
    },
    {
      title: 'Freelancer Olarak İlk 10.000₺',
      views: 67800,
      likes: 3200,
      comments: 412,
      date: '2026-03-10'
    },
    {
      title: 'Claude Code ile Uygulama Geliştirme',
      views: 52300,
      likes: 2400,
      comments: 301,
      date: '2026-03-05'
    },
    {
      title: 'Yapay Zeka Araçları 2026: En İyiler',
      views: 89100,
      likes: 4100,
      comments: 523,
      date: '2026-02-28'
    },
    {
      title: 'Web Scraping Nedir? Kimler Kullanmalı?',
      views: 31400,
      likes: 1300,
      comments: 167,
      date: '2026-02-22'
    },
    {
      title: 'Notion ile Proje Yönetimi Sistemi Kur',
      views: 28900,
      likes: 1150,
      comments: 145,
      date: '2026-02-18'
    },
    {
      title: 'API Nedir? 10 Dakikada Öğren',
      views: 41200,
      likes: 1900,
      comments: 213,
      date: '2026-02-12'
    },
    {
      title: 'Make vs n8n: Hangisini Seçmeli?',
      views: 55600,
      likes: 2700,
      comments: 378,
      date: '2026-02-05'
    },
    {
      title: 'E-Ticaret Otomasyonu ile Ayda 50 Saat Kazan',
      views: 72400,
      likes: 3500,
      comments: 445,
      date: '2026-01-29'
    },
    {
      title: 'ChatGPT Prompt Mühendisliği Rehberi',
      views: 93200,
      likes: 4800,
      comments: 612,
      date: '2026-01-20'
    },
    {
      title: 'İlk SaaS Ürününü 1 Haftada Çıkar',
      views: 48700,
      likes: 2200,
      comments: 289,
      date: '2026-01-15'
    }
  ]
};
```

Ek olarak mock daily view data oluştur: son 90 gün için rastgele ama trendi yukarı olan günlük görüntülenme sayıları (8000-25000 arası, hafif artış trendi). `generateMockDailyViews()` fonksiyonu ile.

## Dashboard Render Akışı

1. Sayfa açılır → arama çubuğu gösterilir, dashboard gizli
2. URL girilip "Verileri Çek" tıklanır → loading state
3. API çağrısı yapılır:
   - Başarılı → veriyi normalize et → dashboard'u render et
   - Başarısız → hata mesajı + "Mock verilerle devam et" butonu
4. "Örnek verilerle incele" tıklanırsa → mock data → dashboard'u render et
5. Dashboard render sırası:
   - Stat kartları (animasyonlu counterlar başlar)
   - Trend grafiği (SVG çizilir)
   - Son videolar tablosu
   - En iyi videolar
   - Demografik tahmin

Tüm dashboard elemanları staggered fade-in animasyonu ile görünür (her bölüm 100ms arayla).

## Veri Yapıları

```javascript
// Normalize edilmiş kanal verisi
const channelData = {
  name: '',
  subscribers: 0,
  totalViews: 0,
  videoCount: 0,
  avgViews: 0,
  videos: [
    {
      title: '',
      views: 0,
      likes: 0,
      comments: 0,
      date: '',        // ISO format
      dateFormatted: '' // "15 Mar 2026" format
    }
  ],
  dailyViews: [
    { date: '2026-03-27', views: 15200 }
  ]
};

// Aktif filtre
let activeTimePeriod = 30; // 7 | 30 | 90
```

## Sayı Formatlama

```javascript
// Türkçe ay isimleri
const months = ['Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'];

function formatDate(isoDate) {
  const d = new Date(isoDate);
  return `${d.getDate()} ${months[d.getMonth()]} ${d.getFullYear()}`;
}
```

## SVG Grafik Detayları

Trend grafiği SVG yapısı:
```html
<svg viewBox="0 0 800 300" preserveAspectRatio="xMidYMid meet">
  <!-- Grid çizgileri -->
  <line x1="60" y1="..." x2="780" y2="..." stroke="rgba(255,255,255,0.05)" />

  <!-- Y ekseni etiketleri -->
  <text x="55" y="..." text-anchor="end" fill="rgba(255,255,255,0.5)" font-size="11">45K</text>

  <!-- Alan dolgusu -->
  <defs>
    <linearGradient id="areaGrad" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0%" stop-color="#ff0000" stop-opacity="0.25"/>
      <stop offset="100%" stop-color="#ff0000" stop-opacity="0"/>
    </linearGradient>
  </defs>
  <polygon points="..." fill="url(#areaGrad)" />

  <!-- Çizgi -->
  <polyline points="..." fill="none" stroke="#ff0000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />

  <!-- Veri noktaları (hover için) -->
  <circle cx="..." cy="..." r="4" fill="#ff0000" />

  <!-- X ekseni etiketleri -->
  <text x="..." y="290" text-anchor="middle" fill="rgba(255,255,255,0.5)" font-size="11">15 Mar</text>
</svg>
```

Veri noktalarını SVG koordinatlarına çevirme:
- X: tarih index'ini 60-780 arasına eşle
- Y: görüntülenme sayısını 20-260 arasına ters eşle (büyük sayı = düşük Y)

## Responsive Breakpoints

- Desktop (>1024px): 4 stat kartı yan yana, grafik ve tablo 2 kolon
- Tablet (768-1024px): 2'li stat grid, tek kolon alt kısım
- Mobil (<768px): tek kolon her şey, tablo yatay scroll, stat kartları 2x2 grid

## Önemli Kurallar

- TEK DOSYA: sadece index.html — tüm CSS ve JS inline
- HARİCİ KÜTÜPHANE YOK — saf HTML/CSS/JS
- Google Fonts DM Sans hariç harici kaynak yok
- Tüm metinler Türkçe
- Apify entegrasyonu gerçek API çağrısı olacak (API key placeholder ile)
- API key satırı kodda açıkça görünecek: `const APIFY_TOKEN = 'TOKEN_BURAYA_GIRIN'`
- API timeout: 60 saniye (AbortController ile)
- API hatalarını graceful handle et — her zaman mock data fallback
- SVG grafikler inline (harici dosya yok)
- Animasyonlu counterlar easeOutExpo ile
- Sayı formatı Türkçe (nokta ayracı)
- Performanslı: smooth animasyonlar, 60fps
- Erişilebilir: semantic HTML, ARIA labels, tablo scope attribute'ları

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

