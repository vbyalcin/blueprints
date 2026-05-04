# Fatura Olusturucu

## Genel Bakis
Canli onizlemeli profesyonel fatura olusturucu. Sol tarafta editor formu, sag tarafta beyaz A4 fatura onizlemesi. PDF indirme destegi. API gerektirmez.

## Teknik Gereksinimler
- **Tek dosya:** `index.html` (inline CSS + JS)
- **Font:** DM Sans (Google Fonts)
- **Tema:** Koyu (#0a0a0a arka plan), aksent renk #14b8a6 (teal)
- **Dil:** Turkce
- **Framework:** Yok — vanilla HTML/CSS/JS

## Sayfa Yapisi

### Header
- Sol: "Fatura Olusturucu" baslik
- Sag: "PDF Indir" butonu (#14b8a6), "Yeni Fatura" butonu (outline), "Yazdir" butonu (outline)

### Ana Layout (2 sutun, esit genislik)

#### Sol Sutun: Editor Formu

**Fatura Bilgileri (ust kisim)**
- Fatura No: Otomatik uretilir, format `FTR-2026-001` (duzenlenebilir)
- Fatura Tarihi: date input (varsayilan: bugun)
- Vade Tarihi: date input (varsayilan: bugun + 30 gun)
- Durum: dropdown — Taslak, Gonderildi, Odendi, Gecikti

**Isletme Bilgileri (kart)**
Baslik: "Gonderen"
- Sirket Adi: text input
- Vergi Dairesi: text input
- Vergi No: text input
- Adres: textarea
- Telefon: tel input
- Email: email input

**Musteri Bilgileri (kart)**
Baslik: "Alici"
- Sirket/Kisi Adi: text input
- Vergi Dairesi: text input
- Vergi No: text input
- Adres: textarea
- Telefon: tel input
- Email: email input

**Kalem Listesi (kart)**
Baslik: "Kalemler"
Her kalem bir satir:
- Aciklama: text input (genis)
- Miktar: number input (dar)
- Birim Fiyat: number input (dar), TL sembolu
- KDV Orani: dropdown — %0, %10, %20
- Tutar: otomatik hesaplanan (miktar x birim fiyat), readonly
- Sil butonu (x ikonu)

"+ Kalem Ekle" butonu — yeni bos satir ekler

**Ozet (kalem listesinin altinda)**
- Ara Toplam: otomatik (tum kalemlerin toplami)
- KDV (%10): otomatik (ilgili kalemlerin KDV'si)
- KDV (%20): otomatik
- **Genel Toplam:** otomatik, bold, buyuk yazi

**Notlar (kart)**
- Ek notlar: textarea
- Banka bilgileri: textarea (IBAN vs.)

#### Sag Sutun: Canli Fatura Onizlemesi

Beyaz arka planli (#ffffff), A4 oranli (yaklasiik 595x842px oraniyla), golge efekti (box-shadow), sayfa icinde ortali.

**Fatura Sablon Tasarimi:**

```
┌──────────────────────────────────────────┐
│                                          │
│  [SIRKET ADI]              FATURA        │
│  Vergi Dairesi: XXX                      │
│  Vergi No: XXX             Fatura No:    │
│  Adres satir 1             FTR-2026-001  │
│  Tel: XXX                  Tarih: XX.XX  │
│  Email: XXX                Vade: XX.XX   │
│                                          │
│  ─────────────────────────────────────── │
│                                          │
│  ALICI                                   │
│  Sirket/Kisi Adi                         │
│  Vergi Dairesi: XXX                      │
│  Vergi No: XXX                           │
│  Adres                                   │
│                                          │
│  ─────────────────────────────────────── │
│                                          │
│  # │ Aciklama    │ Miktar │ Fiyat │ KDV  │ Tutar │
│  ──┼─────────────┼────────┼───────┼──────┼───────│
│  1 │ Web Sitesi  │   1    │ 15000 │ %20  │15.000 │
│  2 │ SEO Paketi  │   3    │  2500 │ %20  │ 7.500 │
│  3 │ Logo Tasarim│   1    │  5000 │ %20  │ 5.000 │
│  4 │ Hosting     │  12    │   150 │ %20  │ 1.800 │
│  5 │ Danismanlik │   5    │  1000 │ %10  │ 5.000 │
│                                          │
│  ─────────────────────────────────────── │
│                                          │
│                  Ara Toplam:  34.300,00 TL│
│                  KDV (%10):     500,00 TL │
│                  KDV (%20):   5.860,00 TL │
│                  ─────────────────────── │
│                  GENEL TOPLAM: 40.660,00 TL│
│                                          │
│  ─────────────────────────────────────── │
│                                          │
│  Notlar:                                 │
│  Odeme 30 gun icinde yapilmalidir.       │
│                                          │
│  Banka: Ziraat Bankasi                   │
│  IBAN: TR00 0000 0000 0000 0000 0000 00  │
│                                          │
└──────────────────────────────────────────┘
```

Onizleme **gercek zamanli** guncellenir — editor'daki her degisiklik aninda yansir (input event listener).

Fatura onizlemesinde renkler:
- Arka plan: beyaz (#ffffff)
- Yazi: koyu (#1a1a1a)
- Basliklar: #333333
- Tablo header: #f3f4f6 arka plan
- Tablo border: #e5e7eb
- Toplam satiri: bold, buyuk
- Sirket adi: aksent renk (#14b8a6) veya siyah, kalin

### On Yuklu Ornek Fatura

**Gonderen:**
```
Dijital Cozumler A.S.
Besiktas Vergi Dairesi
Vergi No: 1234567890
Barbaros Bulvari No:42, Besiktas, Istanbul
+90 212 555 7890
info@dijitalcozumler.com
```

**Alici:**
```
Anadolu Ticaret Ltd. Sti.
Kadikoy Vergi Dairesi
Vergi No: 9876543210
Bagdat Caddesi No:128, Kadikoy, Istanbul
+90 216 555 4321
muhasebe@anadoluticaret.com
```

**Kalemler (5 adet):**
```
1. Web Sitesi Tasarimi ve Gelistirme | 1 adet | 15.000 TL | %20 KDV
2. SEO Optimizasyon Paketi (aylik) | 3 adet | 2.500 TL | %20 KDV
3. Logo ve Kurumsal Kimlik Tasarimi | 1 adet | 5.000 TL | %20 KDV
4. Web Hosting (aylik) | 12 adet | 150 TL | %20 KDV
5. Dijital Pazarlama Danismanligi (saat) | 5 adet | 1.000 TL | %10 KDV
```

**Notlar:**
```
Odeme fatura tarihinden itibaren 30 gun icinde yapilmalidir.
Gecikme durumunda aylik %2 vade farki uygulanir.
```

**Banka Bilgileri:**
```
Ziraat Bankasi - Besiktas Subesi
Hesap Sahibi: Dijital Cozumler A.S.
IBAN: TR12 0001 0012 3456 7890 1234 56
```

### Hesaplamalar
```javascript
// Her kalem icin:
kalemTutar = miktar * birimFiyat;

// KDV hesaplama:
kdv10Toplam = kalemler.filter(k => k.kdvOrani === 10).reduce((t, k) => t + (k.tutar * 0.10), 0);
kdv20Toplam = kalemler.filter(k => k.kdvOrani === 20).reduce((t, k) => t + (k.tutar * 0.20), 0);

// Genel toplam:
araToplam = kalemler.reduce((t, k) => t + k.tutar, 0);
genelToplam = araToplam + kdv10Toplam + kdv20Toplam;
```

Tutarlar Turkce formatlama: `34.300,00 TL` (nokta binlik ayirici, virgul ondalik)

### Fatura No Otomatik Uretim
Format: `FTR-{YIL}-{SIRA}`
- YIL: 4 haneli (2026)
- SIRA: 3 haneli, sifir dolgulu (001, 002, ...)
- localStorage'dan son numarayi oku, 1 artir

### PDF Indirme
"PDF Indir" butonu:
1. Onizleme alanini `window.print()` ile yazdir
2. Print CSS ile:
   - Sadece onizleme alani gorunsun (editor gizle)
   - Beyaz arka plan
   - A4 boyut
   - Kenar bosluklari: 20mm
   - Golge ve border kaldir
   - Tarayici print dialog'u acilir → kullanici PDF olarak kaydedebilir

```css
@media print {
  body * { visibility: hidden; }
  .fatura-onizleme, .fatura-onizleme * { visibility: visible; }
  .fatura-onizleme {
    position: absolute; left: 0; top: 0;
    width: 100%; background: white;
    box-shadow: none; border: none;
  }
}
```

### Ek Ozellikler
- Para birimi degistirme: TL / USD / EUR (dropdown, sadece sembol degisir)
- Kalem sirasi surukle-birak ile degistirme (opsiyonel)
- "Fatura Sablonu" secimi: Klasik / Modern / Minimal (sadece 1 sablon yeterli, diger ikisi "Yakin Zamanda" badge'li)

## Stil Detaylari (Editor Tarafi)
```
Arka plan: #0a0a0a
Kart arka plan: #141414
Border: #222222
Input arka plan: #1a1a1a
Input border: #333333
Input focus border: #14b8a6
Aksent: #14b8a6
Aksent hover: #2dd4bf
Yazi: #e5e5e5
Ikincil yazi: #888888
Label: #aaaaaa
```

## Responsive
- 1024px+: 2 sutun (editor + onizleme yan yana)
- 768px-: Tek sutun, onizleme editoru altinda, sticky "PDF Indir" butonu altta

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

