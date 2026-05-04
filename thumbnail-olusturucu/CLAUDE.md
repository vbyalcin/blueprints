# YouTube Thumbnail Tasarımcı

Bu proje HTML5 Canvas tabanlı bir YouTube thumbnail oluşturma aracı. Tek bir `index.html` dosyası olarak kur — tüm CSS ve JS inline olacak. Harici kütüphane veya framework KULLANMA.

## Genel Bakış

Kullanıcı 1280x720 canvas üzerinde YouTube thumbnail tasarlayabilir:
- 5 hazır şablon
- Arka plan seçenekleri (renk, gradient, **Fal AI ile oluşturulmuş görsel**)
- Metin katmanları (sürükle-bırak, font, renk, outline, gölge)
- Emoji overlayleri
- PNG olarak indirme
- Katman yönetimi paneli

## Tasarım

- **Tema:** Koyu (#0a0a0a arka plan)
- **Font:** DM Sans (Google Fonts'tan yükle)
- **Accent:** YouTube kırmızı (#ff0000)
- **Secondary:** #1a1a1a paneller
- **Kartlar/Paneller:** #141414 arka plan, 1px solid rgba(255,255,255,0.08) border
- **Border radius:** 12px
- **Input/Select:** #1a1a1a bg, #333 border, beyaz text
- **Aktif şablon:** kırmızı border
- **Canvas:** Ortada, gölgeli, #000 arka plan
- **Responsive:** Canvas mobilde küçülür ama oran korunur (16:9)

## Sayfa Düzeni

### Header
- "🎨 Thumbnail Tasarımcı" başlık (h1)
- Alt başlık: "YouTube videolarınız için profesyonel thumbnail oluşturun"
- Sağ üstte "📥 PNG İndir" butonu (her zaman görünür, accent renk)

### Ana Layout — 3 Panel (Desktop)

```
[Sol Panel: 280px] [Canvas: Esnek] [Sağ Panel: 260px]
```

Mobilde: Canvas üstte full-width, paneller alta tab olarak

#### Sol Panel: Araçlar

**Bölüm 1: Şablonlar**
- 5 küçük önizleme kartı (grid 2 kolon), tıklanabilir
- Her şablon canvas'a uygulanır

Şablon detayları:
1. **Eğitim:** Mavi gradient (#1e3a5f → #0a0a0a), sol tarafta büyük beyaz başlık, sağ alt köşede sarı vurgu kutusu
2. **Dikkat Çekici:** Kırmızı-turuncu gradient (#ff0000 → #ff6600), ortada beyaz bold başlık, siyah outline
3. **Minimalist:** Siyah arka plan, ortada tek satır beyaz başlık, altında ince kırmızı çizgi
4. **Karşılaştırma:** Ortadan ikiye bölünmüş (sol yeşil, sağ kırmızı), "VS" ortada, iki başlık alanı
5. **Liste:** Koyu mor gradient (#1a0a2e → #0a0a0a), sol üstte büyük sarı rakam, yanında beyaz başlık

**Bölüm 2: Arka Plan**
- **Renk seçici:** `<input type="color">` ile düz renk
- **Gradient:** 2 renk seçici + yön (dikey/yatay/çapraz) dropdown
- **"Uygula" butonu** her seçenek için
- **"🤖 AI Arka Plan" butonu** (büyük, vurgulu):
  - Tıklanınca bir text input + "Oluştur" butonu görünür
  - Placeholder: "Arka planı tanımla... Örn: uzay, yıldızlar, nebula"
  - Loading durumu: buton disabled, spinner animasyonu, "Oluşturuluyor..."
  - Sonuç: Görsel canvas'a arka plan olarak yüklenir

**AI Arka Plan API Entegrasyonu:**
```javascript
const FAL_KEY = 'KEY_BURAYA_GIRIN';

async function generateAIBackground(description) {
  const response = await fetch('https://fal.run/fal-ai/nano-banana-2', {
    method: 'POST',
    headers: {
      'Authorization': `Key ${FAL_KEY}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      prompt: `${description}, background image, no text, no words, high quality, 16:9`,
      negative_prompt: 'text, words, letters, watermark, blurry, low quality, distorted',
      image_size: 'landscape_16_9',
      num_inference_steps: 25
    })
  });
  const data = await response.json();
  return data.images[0].url;
}
```
- Oluşturulan görsel `Image()` ile yüklenip canvas'a `drawImage()` ile çizilir
- Hata durumu: kırmızı border'lı uyarı mesajı

**Bölüm 3: Metin Ekle**
- "＋ Metin Ekle" butonu
- Tıklanınca canvas'ın ortasına "Metin" yazısı eklenir ve sağ panelde düzenleme açılır

**Bölüm 4: Emoji Ekle**
- Sık kullanılan emojiler grid halinde: 🔥 ⚡ 💡 🎯 🚀 ✅ ❌ ⭐ 💰 🎬 📌 🏆 👆 👇 😱 🤯
- Tıklanınca canvas'ın ortasına eklenir
- Boyut slider'ı (30-150px)

#### Orta: Canvas Alanı

- `<canvas>` elementi, 1280x720 gerçek boyut
- CSS ile görüntü boyutu container'a sığacak şekilde (max-width: 100%, aspect-ratio korunur)
- Canvas etrafında 2px dashed rgba(255,255,255,0.1) border (düzenleme modu hissi)
- Canvas üzerinde elementler mouse ile sürüklenebilir:
  - `mousedown` → hangi elemente tıklandı tespit et
  - `mousemove` → elementi sürükle
  - `mouseup` → bırak
  - Touch eventleri de destekle (`touchstart`, `touchmove`, `touchend`)
- Seçili elementin etrafında kırmızı noktalı border göster
- Canvas altında boyut bilgisi: "1280 × 720px"

#### Sağ Panel: Katman Yönetimi & Özellikler

**Katman Listesi:**
- Her katman bir satır: drag handle (⋮⋮), göz ikonu (görünürlük toggle), isim, silme butonu (🗑️)
- Katman sırası = çizim sırası (üstteki en önde)
- Seçili katman vurgulu (kırmızı sol border)
- Katman tipleri: `background`, `text`, `emoji`

**Seçili Katman Özellikleri (text seçiliyken):**
- **Metin içeriği:** textarea (canlı güncelleme)
- **Font boyutu:** range slider (20-150px) + sayısal gösterge
- **Font ağırlığı:** Normal / Bold toggle
- **Renk:** color picker
- **Outline:** checkbox + renk + kalınlık slider (0-10px)
- **Gölge:** checkbox + renk + blur slider (0-20px) + offset X/Y
- **Hizalama:** Sol / Orta / Sağ butonları
- **Pozisyon:** X ve Y sayısal input (pixel)

**Seçili Katman Özellikleri (emoji seçiliyken):**
- **Boyut:** range slider (30-200px)
- **Pozisyon:** X ve Y sayısal input

## Şablon Uygulama Mantığı

Her şablon uygulandığında:
1. Tüm mevcut katmanları temizle
2. Arka plan katmanı oluştur (gradient/renk)
3. Şablona özel metin katmanları ekle (pozisyon, font, renk hazır)
4. Varsa şekil/dekorasyon katmanları

```javascript
const templates = [
  {
    name: 'Eğitim',
    preview: '📘', // Önizleme ikonu
    background: { type: 'gradient', color1: '#1e3a5f', color2: '#0a0a0a', direction: 'diagonal' },
    layers: [
      { type: 'text', text: 'Başlık Buraya', x: 80, y: 300, fontSize: 72, fontWeight: 'bold', color: '#ffffff', outline: { enabled: true, color: '#000000', width: 3 } },
      { type: 'text', text: 'Alt Başlık', x: 80, y: 400, fontSize: 36, fontWeight: 'normal', color: '#f59e0b', outline: { enabled: false } }
    ]
  },
  // ... diğer 4 şablon
];
```

## Canvas Render Döngüsü

```javascript
function render() {
  ctx.clearRect(0, 0, 1280, 720);

  // 1. Arka plan çiz
  drawBackground();

  // 2. Katmanları sırayla çiz (alttan üste)
  layers.forEach(layer => {
    if (!layer.visible) return;
    if (layer.type === 'text') drawText(layer);
    if (layer.type === 'emoji') drawEmoji(layer);
  });

  // 3. Seçili elementin selection border'ını çiz
  if (selectedLayer) drawSelectionBorder(selectedLayer);
}
```

Her değişiklikte `render()` çağrılır. `requestAnimationFrame` kullanmaya gerek yok (event-driven yeterli).

## Veri Yapıları

```javascript
// Katman yapısı
const layers = [
  {
    id: 'layer_1',
    type: 'text',      // 'text' | 'emoji' | 'shape'
    text: 'Başlık',
    x: 100,
    y: 300,
    fontSize: 72,
    fontWeight: 'bold', // 'normal' | 'bold'
    color: '#ffffff',
    outline: { enabled: true, color: '#000000', width: 3 },
    shadow: { enabled: false, color: '#000000', blur: 10, offsetX: 2, offsetY: 2 },
    align: 'left',     // 'left' | 'center' | 'right'
    visible: true
  },
  {
    id: 'layer_2',
    type: 'emoji',
    emoji: '🔥',
    x: 600,
    y: 200,
    size: 80,
    visible: true
  }
];

// Arka plan
const background = {
  type: 'solid',       // 'solid' | 'gradient' | 'image'
  color: '#0a0a0a',
  gradient: { color1: '#1e3a5f', color2: '#0a0a0a', direction: 'vertical' },
  imageUrl: null        // AI tarafından oluşturulmuş URL
};

let selectedLayerId = null;
let isDragging = false;
let dragOffset = { x: 0, y: 0 };
```

## PNG İndirme

```javascript
function downloadPNG() {
  // Seçim border'ını kaldırarak temiz render
  const tempSelected = selectedLayerId;
  selectedLayerId = null;
  render();

  const link = document.createElement('a');
  link.download = 'thumbnail.png';
  link.href = canvas.toDataURL('image/png');
  link.click();

  selectedLayerId = tempSelected;
  render();
}
```

**Not:** AI ile oluşturulmuş arka plan görseli cross-origin olabilir. `img.crossOrigin = 'anonymous'` ayarla ki `toDataURL` çalışsın. Eğer CORS hatası olursa kullanıcıya bilgi ver.

## Hit Detection (Tıklama Algılama)

```javascript
function getLayerAtPoint(x, y) {
  // Üstten alta (en öndeki katmandan) kontrol et
  for (let i = layers.length - 1; i >= 0; i--) {
    const layer = layers[i];
    if (!layer.visible) continue;

    if (layer.type === 'text') {
      ctx.font = `${layer.fontWeight} ${layer.fontSize}px 'DM Sans'`;
      const metrics = ctx.measureText(layer.text);
      const width = metrics.width;
      const height = layer.fontSize;
      if (x >= layer.x && x <= layer.x + width && y >= layer.y - height && y <= layer.y) {
        return layer;
      }
    }

    if (layer.type === 'emoji') {
      const half = layer.size / 2;
      if (x >= layer.x - half && x <= layer.x + half && y >= layer.y - half && y <= layer.y + half) {
        return layer;
      }
    }
  }
  return null;
}
```

Mouse koordinatlarını canvas koordinatlarına çevir:
```javascript
function getCanvasCoords(e) {
  const rect = canvas.getBoundingClientRect();
  const scaleX = 1280 / rect.width;
  const scaleY = 720 / rect.height;
  return {
    x: (e.clientX - rect.left) * scaleX,
    y: (e.clientY - rect.top) * scaleY
  };
}
```

## Başlangıç Durumu

Sayfa açıldığında:
- Canvas siyah arka plan (#0a0a0a)
- Ortada kırmızı "Başlamak için bir şablon seç veya metin ekle" yazısı (guide text, ilk katman eklenince kaybolur)
- Sol panelde şablonlar görünür
- Sağ panelde "Katman seçilmedi" mesajı

## Responsive Breakpoints

- Desktop (>1024px): 3 panel yan yana
- Tablet (768-1024px): Sol panel üstte yatay, canvas ortada, sağ panel alta
- Mobil (<768px): Canvas full-width üstte (16:9 oranı korunur), araçlar alt kısımda tab navigasyonu ile (Şablonlar | Arka Plan | Metin | Katmanlar)

## Önemli Kurallar

- TEK DOSYA: sadece index.html — tüm CSS ve JS inline
- HARİCİ KÜTÜPHANE YOK — saf HTML/CSS/JS
- Google Fonts DM Sans hariç harici kaynak yok
- Tüm metinler Türkçe
- Canvas gerçek boyut: 1280x720, ekran boyutu: responsive
- Fal AI entegrasyonu gerçek API çağrısı olacak (API key placeholder ile)
- API key satırı kodda açıkça görünecek: `const FAL_KEY = 'KEY_BURAYA_GIRIN'`
- AI görsellerinde `crossOrigin = 'anonymous'` ayarla
- PNG indirme `canvas.toDataURL()` ile
- Sürükle-bırak hem mouse hem touch destekli
- Performanslı render: her değişiklikte tek `render()` çağrısı
- Erişilebilir: semantic HTML, ARIA labels

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

