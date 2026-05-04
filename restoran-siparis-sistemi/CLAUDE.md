# Restoran Dijital Sipariş & Menü Sistemi

Bu proje bir restoran için eksiksiz bir dijital sipariş ve menü yönetim sistemi. Tek bir `index.html` dosyası olarak kur — tüm CSS ve JS inline olacak. Harici kütüphane veya framework KULLANMA.

## Genel Bakış

Sistem 3 görünümden oluşuyor, URL hash ile yönetiliyor:
- `#menu` — Müşteri menü & sipariş sayfası (varsayılan)
- `#mutfak` — Mutfak ekranı (gelen siparişler)
- `#yonetim` — Restoran yönetim paneli

Tüm veri localStorage'da tutuluyor. Sayfalar arası iletişim `storage` event ile sağlanıyor — böylece mutfak ekranı ayrı sekmede açıkken yeni siparişler anında görünüyor.

## Tasarım

- **Tema:** Koyu (#0a0a0a arka plan)
- **Font:** DM Sans (Google Fonts'tan yükle)
- **Müşteri sayfası accent:** Turuncu/amber (#f59e0b)
- **Mutfak ekranı accent:** Kırmızı (#ef4444)
- **Yönetim paneli accent:** Mavi (#3b82f6)
- **Border radius:** 12px
- **Kartlar:** #141414 arka plan, 1px solid rgba(255,255,255,0.08) border
- **Animasyonlar:** Fade-in, smooth transitions, kart hover efektleri
- **Responsive:** Müşteri sayfası mobilde mükemmel çalışmalı (telefon ekranı)

## Restoran Bilgileri (Sabit Veri)

```
Restoran Adı: Ateş Kebap & Izgara
Slogan: "Odun ateşinde, geleneksel lezzet"
Çalışma Saatleri: 11:00 - 23:00
Adres: Bağdat Caddesi No:42, Kadıköy, İstanbul
Telefon: 0216 345 67 89
```

## Menü Verileri

### Başlangıçlar
| Ürün | Açıklama | Fiyat |
|------|----------|-------|
| Mercimek Çorbası | Geleneksel kırmızı mercimek çorbası, limon ile servis | ₺65 |
| Ezme | Acılı domates ezmesi, taze yeşillikler | ₺55 |
| Humus | Tahin soslu nohut ezmesi, zeytinyağı | ₺60 |
| Sigara Böreği (4 adet) | Çıtır yufka, beyaz peynir | ₺75 |
| Patlıcan Salatası | Közlenmiş patlıcan, sarımsak, nar ekşisi | ₺65 |
| Atom | Acı biber, sarımsak yoğurt, nar ekşisi | ₺50 |

### Ana Yemekler
| Ürün | Açıklama | Fiyat |
|------|----------|-------|
| Adana Kebap | El kıyması, odun ateşinde, lavaş ekmek ile | ₺195 |
| Urfa Kebap | Acısız el kıyması, közlenmiş domates, biber | ₺195 |
| Beyti Sarma | Lavaş sarma, yoğurt ve tereyağlı sos | ₺225 |
| Kuzu Pirzola (4 adet) | Marine edilmiş kuzu pirzola, ızgara sebze | ₺345 |
| Tavuk Kanat (8 adet) | Baharatlı ızgara kanat, ranch sos | ₺165 |
| İskender | İnce döner, tereyağlı domates sos, yoğurt | ₺215 |
| Karışık Izgara (2 kişilik) | Adana, kanat, pirzola, köfte, sebze | ₺495 |
| Köfte (6 adet) | Kasap köftesi, ızgara ile | ₺175 |

### Yan Ürünler
| Ürün | Açıklama | Fiyat |
|------|----------|-------|
| Pilav | Tereyağlı pirinç pilavı | ₺45 |
| Lavaş Ekmek | Fırın lavaş (2 adet) | ₺25 |
| Közlenmiş Biber | 3 adet közlenmiş sivri biber | ₺35 |
| Piyaz | Kuru fasulye salatası, soğan, maydanoz | ₺50 |
| Çoban Salata | Domates, salatalık, soğan, maydanoz | ₺55 |
| Mevsim Salata | Akdeniz yeşillikleri, nar ekşili sos | ₺65 |

### İçecekler
| Ürün | Açıklama | Fiyat |
|------|----------|-------|
| Ayran | Geleneksel yayık ayran | ₺30 |
| Şalgam | Acılı şalgam suyu | ₺30 |
| Kola / Fanta / Sprite | 330ml kutu | ₺45 |
| Su (0.5L) | | ₺15 |
| Çay | İnce belli bardak | ₺20 |
| Türk Kahvesi | Orta şekerli | ₺45 |
| Taze Limonata | Ev yapımı, nane | ₺55 |

### Tatlılar
| Ürün | Açıklama | Fiyat |
|------|----------|-------|
| Künefe | Sıcak peynirli künefe, kaymak ile | ₺120 |
| Katmer | Fıstıklı Gaziantep katmeri | ₺110 |
| Sütlaç | Fırında sütlaç | ₺75 |
| Baklava (4 adet) | Fıstıklı ev baklavası | ₺95 |

## Sayfa 1: Müşteri Menü & Sipariş (#menu)

### Header
- Restoran logosu (metin bazlı: "🔥 Ateş Kebap")
- Masa numarası seçici (Masa 1-20, dropdown veya ilk açılışta modal ile seç)
- Sepet ikonu + ürün sayısı badge

### Kategori Navigasyonu
- Yatay scroll yapılabilen kategori butonları: Başlangıçlar, Ana Yemekler, Yan Ürünler, İçecekler, Tatlılar
- Tıklanan kategori active state, ilgili bölüme smooth scroll
- Sticky pozisyon (scroll'da sabit kalsın)

### Menü Listesi
- Her kategorinin başlığı ve altında ürün kartları
- Ürün kartı: ürün adı, açıklama, fiyat, adet seçici (+/- butonları)
- Adet 0'dan büyükse kart aktif görünsün (border rengi değişsin)
- Smooth animasyon ile adet değişimi

### Sepet (Drawer — sağdan açılır)
- Sepet ikonuna tıklayınca sağdan slide-in panel
- Seçilen ürünler listesi: ad, adet, birim fiyat, toplam
- Adet değiştirme (+/-) ve silme butonu
- Ara toplam
- Sipariş notu textarea
- "Sipariş Ver" butonu
- Sipariş verildiğinde:
  - localStorage'a kaydet (sipariş ID, masa no, ürünler, zaman, durum: "yeni")
  - Konfirmasyon animasyonu (yeşil checkmark)
  - Sepeti temizle
  - "Siparişiniz mutfağa iletildi!" mesajı

### Alt Bilgi
- Çalışma saatleri, adres, telefon

## Sayfa 2: Mutfak Ekranı (#mutfak)

### Header
- "🍳 Mutfak Ekranı" başlık
- Anlık sipariş sayısı
- Ses bildirimi: yeni sipariş geldiğinde kısa beep sesi (Web Audio API ile üret, dosya kullanma)

### Sipariş Kartları — 3 sütunlu Kanban
**Sütun 1: Yeni Siparişler** (kırmızı accent)
- Yeni gelen siparişler burada görünür
- Kart: masa no, sipariş zamanı, ürün listesi, sipariş notu
- "Hazırlanıyor" butonu → sütun 2'ye taşı

**Sütun 2: Hazırlanıyor** (amber accent)
- Hazırlanan siparişler
- Kart aynı bilgiler + geçen süre (kaç dakikadır hazırlanıyor)
- "Hazır" butonu → sütun 3'e taşı

**Sütun 3: Tamamlandı** (yeşil accent)
- Son 10 tamamlanmış sipariş
- Toplam hazırlanma süresi göster

### Otomatik Güncelleme
- `window.addEventListener('storage', ...)` ile yeni siparişleri yakala
- Yeni sipariş gelince kart animasyonla girer + ses çalar
- Her saniye sayaçları güncelle

## Sayfa 3: Yönetim Paneli (#yonetim)

### Sidebar
- Dashboard
- Siparişler
- Menü Düzenle (bonus — basit tutabilirsin)
- İstatistikler

### Dashboard Görünümü
- Stat kartları:
  - Bugünkü sipariş sayısı
  - Bugünkü gelir (₺)
  - Ortalama sipariş tutarı
  - En çok sipariş edilen ürün
- Son siparişler tablosu: sipariş no, masa, tutar, durum, zaman
- Basit SVG çubuk grafik: son 7 günün geliri (mock veri)

### Siparişler Görünümü
- Tüm siparişlerin tablosu
- Filtreleme: durum, tarih, masa
- Sipariş detayı modal

## Teknik Detaylar

### Veri Yapısı (localStorage)

```javascript
// Menü verisi (başlangıçta hard-coded, sonra localStorage'dan okunur)
menuData = {
  categories: [
    {
      id: "baslangiclar",
      name: "Başlangıçlar",
      emoji: "🥗",
      items: [
        { id: "mercimek", name: "Mercimek Çorbası", desc: "...", price: 65 },
        // ...
      ]
    },
    // ...
  ]
}

// Sipariş verisi
orders = [
  {
    id: "ORD-001",
    table: 5,
    items: [ { id: "adana", name: "Adana Kebap", qty: 2, price: 195 } ],
    note: "Acısız olsun",
    status: "yeni", // yeni | hazirlaniyor | tamamlandi
    createdAt: "2026-03-27T20:15:00",
    completedAt: null,
    total: 390
  }
]
```

### Navigasyon
- `window.location.hash` ile sayfa yönetimi
- `hashchange` event listener
- Her hash değişiminde ilgili görünümü render et
- Varsayılan: `#menu`

### Demo Verisi
- Sayfa ilk açıldığında 5 örnek sipariş oluştur (farklı durumlarda: 2 yeni, 2 hazırlanıyor, 1 tamamlandı)
- Gerçekçi masa numaraları ve ürün kombinasyonları kullan

## Önemli Kurallar
- TEK DOSYA: sadece index.html — tüm CSS ve JS inline
- HARİCİ KÜTÜPHANE YOK — saf HTML/CSS/JS
- Google Fonts DM Sans hariç harici kaynak yok
- Tüm metinler Türkçe
- Mobil uyumlu (müşteri sayfası özellikle)
- localStorage ile veri kalıcılığı
- Sayfalar arası storage event ile gerçek zamanlı iletişim
- Performanslı: smooth animasyonlar, 60fps
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

