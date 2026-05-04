# Cold Email Kampanya Yoneticisi

## Genel Bakis
B2B cold email kampanyalarini yoneten bir kontrol paneli. Onceden doldurulmus 3 kampanya, email dizisi editoru, kisi birlestirme alanlari ve gorsel donusum hunisi icerir. API gerektirmez.

## Teknik Gereksinimler
- **Tek dosya:** `index.html` (inline CSS + JS)
- **Font:** DM Sans (Google Fonts)
- **Tema:** Koyu (#0a0a0a arka plan), aksent renk #3b82f6 (mavi)
- **Dil:** Turkce
- **Framework:** Yok — vanilla HTML/CSS/JS

## Sayfa Yapisi

### Header
- Sol: "Email Kampanya Yoneticisi" baslik
- Sag: "Yeni Kampanya" butonu (#3b82f6)

### Istatistik Kartlari (5 kart, tek satir)
1. **Aktif Kampanya** — 3
2. **Toplam Gonderilen** — 2,847
3. **Acilma Orani** — %42.3
4. **Yanit Orani** — %8.7
5. **Toplanti Ayarlanan** — 24

Her kart: #141414 arka plan, ust kisimda buyuk rakam, altinda etiket, sag ust kosede kucuk trend ikonu (yesil yukari veya kirmizi asagi)

### Kampanya Kartlari (3 on yuklu kampanya)
Her kampanya yatay kart:

**Kampanya 1: "SaaS Karar Vericiler - Q1"**
- Durum: Aktif (yesil badge)
- Gonderilen: 1,247 | Acilan: 524 (%42) | Yanit: 112 (%9) | Toplanti: 14
- Ilerleme cubugu: gonderim tamamlanma yuzdesi
- Baslangic: 15 Ocak 2026
- "Detay" ve "Duraklat" butonlari

**Kampanya 2: "E-ticaret Yoneticileri"**
- Durum: Aktif (yesil badge)
- Gonderilen: 892 | Acilan: 401 (%45) | Yanit: 78 (%8.7) | Toplanti: 8
- Baslangic: 3 Subat 2026

**Kampanya 3: "Startup Kuruculari"**
- Durum: Tamamlandi (gri badge)
- Gonderilen: 708 | Acilan: 283 (%40) | Yanit: 56 (%7.9) | Toplanti: 2
- Baslangic: 10 Aralik 2025

### Kampanya Detay Gorunumu
Bir kampanyaya tiklandiginda genisleyen veya ayri gorunum:

#### Email Dizisi Editoru
5 adimli email dizisi, her adim bir kart:

**Adim 1 — Ilk Temas (Gun 0)**
```
Konu: {sirket} icin otomasyon onerisi
---
Merhaba {ad},

{sirket}'teki {pozisyon} roluyle ilgili olarak size ulasmak istedim.
Sizin sektorunuzdeki sirketlerin tekrarlayan islemleri otomatiklestirerek
ayda ortalama 40 saat tasarruf ettigini gorduk.

15 dakikalik bir gorusme icin musait olur musunuz?

Saygilarimla,
Esad
```

**Adim 2 — Takip 1 (Gun 3)**
```
Konu: Re: {sirket} icin otomasyon onerisi
---
Merhaba {ad},

Gecen gunku mesajimi gorebildiniz mi?

{sirket} gibi sirketlerin en cok zaman kaybettigi 3 noktayi
icerir bir rapor hazirliyorum. Sizinle paylasmak isterim.

Iyi gunler,
Esad
```

**Adim 3 — Deger Oner (Gun 7)**
```
Konu: {sirket} icin hazirladigim analiz
---
{ad} Bey/Hanim,

{sirket}'in web sitesini inceledim ve 3 otomasyon firsati tespit ettim:
1. Musteri onboarding sureci
2. Teklif hazirlama
3. Raporlama

Bunlarin detaylarini 15 dk'da anlatabilrim.
Bu hafta musait misiniz?

Esad
```

**Adim 4 — Son Takip (Gun 12)**
```
Konu: Son bir kontrol - {ad}
---
Merhaba {ad},

Birkaç kez ulasmaya calistim ama donus alamadim.
Belki simdi uygun bir zaman degildir, anlayisla karsilarim.

Ilerde ilgilenirseniz bu linki kaydedebilirsiniz: [takvim linki]

Kolay gelsin,
Esad
```

**Adim 5 — Ayrilma (Gun 18)**
```
Konu: Dosyani kapatiyorum {ad}
---
{ad}, merhaba.

Yanitlamak istemediginizi anliyorum — sorun degil!
Otomasyon konusunda fikir degistirirseniz
bu mail'e yanit vermeniz yeterli.

Basarilar dilerim,
Esad
```

Her adim kartinda:
- Adim numarasi ve gecikme gunu (duzenlenebilir dropdown: 1-30 gun)
- Konu satiri (duzenlenebilir input)
- Email govdesi (duzenlenebilir textarea)
- Sag tarafta o adimin istatistikleri: gonderilen, acilan, yanit

#### Merge Alanlari
Editorde `{ad}`, `{sirket}`, `{pozisyon}` alanlari vurgulanir (mavi arka plan, rounded).
Ust tarafta "Onizleme" butonu — tiklandiginda ornek veriyle doldurulmus halini gosterir:
- {ad} → "Ahmet"
- {sirket} → "Marmara Yazilim"
- {pozisyon} → "CTO"

#### Gorsel Donusum Hunisi
Dikey huni grafigi (CSS ile):
```
Gonderilen ████████████████████████████ 1,247 (%100)
Teslim      ██████████████████████████  1,196 (%95.9)
Acilan       ████████████████████       524   (%42.0)
Tiklanan      █████████████             287   (%23.0)
Yanitlayan     ████████                 112   (%9.0)
Toplanti        ████                    14    (%1.1)
```

Her seviye farkli genislikte bar, soldan saga daralan. Renk gradyani: mavi → acik mavi.
Hover'da tooltip ile detayli bilgi.

### Kisi Listesi Paneli (alt kisim veya tab)
Kampanyadaki kisilerin listesi (10 kayit/kampanya):

| Ad Soyad | Sirket | Pozisyon | Email | Durum | Son Etkilesim |
|-----------|--------|----------|-------|-------|---------------|
| Ahmet Yilmaz | Marmara Yazilim | CTO | ahmet@marmara.com | Yanit Verdi | 2 gun once |
| Zeynep Kaya | Atlas Hukuk | Kurucu | zeynep@atlas.com | Acildi | 5 gun once |
| ... | ... | ... | ... | ... | ... |

Durum badge renkleri:
- Yanit Verdi: yesil
- Acildi: mavi
- Teslim Edildi: gri
- Toplanti: mor
- Bounce: kirmizi

### Yeni Kampanya Modal
"Yeni Kampanya" butonuna tiklandiginda:
- Kampanya adi (text input)
- Hedef liste (dosya yukle veya manuel gir)
- Email dizisi sablonu sec (3 hazir sablon)
- Gunluk gonderim limiti (dropdown: 25, 50, 100)
- "Olustur" butonu — kampanyayi listeye ekler

## Stil Detaylari
```
Arka plan: #0a0a0a
Kart arka plan: #141414
Border: #222222
Aksent: #3b82f6
Aksent hover: #60a5fa
Basari/Yanit: #10b981
Uyari/Acildi: #f59e0b
Hata/Bounce: #ef4444
Toplanti: #8b5cf6
Yazi: #e5e5e5
Ikincil yazi: #888888
Merge alan vurgu: #3b82f620 arka plan, #3b82f6 border
```

## Responsive
- 1024px+: Tam layout
- 768px-: Kartlar tek sutun, tablo yatay scroll, huni dikey kucultulur

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

