# Portfolio Site Builder — Uygulama Spesifikasyonu

## Genel Bakis

Tarayici icinde calisan, surukleme ve birakma destekli bir portfolyo site olusturucu. Kullanici hazir bilesenleri ekleyerek, duzenleyerek ve siralayarak kendi portfolyo sayfasini olusturur. Fal AI entegrasyonu ile profil fotografi ve proje gorselleri uretilir. Sonuc tek bir HTML dosyasi olarak indirilir.

## Teknik Gereksinimler

- **Tek dosya:** `index.html` — tum CSS ve JS inline
- **Font:** DM Sans (Google Fonts)
- **Tema:** Koyu arka plan `#0a0a0a`, yazi rengi `#e5e5e5`
- **Vurgu rengi:** Emerald `#10b981`
- **Dil:** Turkce
- **Framework:** Yok — vanilla HTML/CSS/JS

## Sayfa Yapisi — 3 Panel Duzen

```
+------------------+------------------------+------------------+
|   Sol Panel      |    Orta Panel          |   Sag Panel      |
|   (250px)        |    (esnek genislik)    |   (300px)        |
|                  |                        |                  |
|   Bilesen        |    Canli On Izleme     |   Ozellik        |
|   Bloklari       |                        |   Duzenleyici    |
+------------------+------------------------+------------------+
```

### Sol Panel — Bilesen Bloklari

Ust kisimda baslik: "Bilesenler"

Her bilesen bir kart olarak gosterilir (ikon + isim). Tiklayinca orta paneldeki on izlemeye eklenir.

Bilesenler:

1. **Hero** — Buyuk baslik, alt baslik, profil fotografi, CTA butonu
2. **Hakkimda** — Metin blogu, kucuk profil gorseli, yetenekler listesi
3. **Projeler** — Kart grid (2 sutun), her kartta gorsel, baslik, aciklama, link
4. **Deneyim** — Timeline (dikey cizgi), sirket adi, pozisyon, tarih, aciklama
5. **Iletisim** — Form (isim, email, mesaj), sosyal medya ikon linkleri

Her bilesen kartinin saginda kucuk `+` ikonu olsun.

Altta renk temasi secimi:
- Mor (`#8b5cf6`)
- Mavi (`#3b82f6`)
- Yesil (`#10b981`)
- Sicak (`#f59e0b`)

Tema secildiginde tum vurgu renkleri degisir.

### Orta Panel — Canli On Izleme

- Arka plan `#111111`, hafif golge ile cercevelenmis
- Eklenen bilesenler dikey sirada gosterilir
- Her bilesenin ustunde hover'da gorunen araç cubugu: yukari/asagi ok (siralama), cop kutusu (sil)
- Bir bilesene tiklandiginda sag panelde o bilesenin ozellikleri acilir
- Secili bilesen `2px solid [vurgu-rengi]` border ile vurgulanir
- Bilesenler suruklenerek (drag & drop) yeniden siralanabilir — HTML5 Drag and Drop API kullan

**Baslangic durumu:** Uygulama acildiginda ornek bir portfolyo yuklu gelir:
- Hero: "Merhaba, ben Arda" / "Full-Stack Gelistirici" / placeholder profil gorseli
- Hakkimda: Ornek bir tanitim metni, yetenekler: React, Node.js, Python, PostgreSQL, Docker
- Projeler: 3 ornek proje (E-Ticaret, Task Manager, Hava Durumu Uygulamasi)
- Deneyim: 2 ornek deneyim
- Iletisim: Ornek sosyal linkler

### Sag Panel — Ozellik Duzenleyici

Baslik: secili bilesenin adi (orn. "Hero Ayarlari")

Secili bilesene gore dinamik form alanlari gosterilir:

**Hero Ayarlari:**
- Baslik (text input)
- Alt baslik (text input)
- CTA butonu metni (text input)
- CTA butonu linki (text input)
- Profil gorseli URL (text input)
- **"AI Profil Fotografi Olustur" butonu** (yesil, Fal AI ikonu)
  - Tiklayinca bir modal/acilir alan gosterilir
  - Textarea: "Kendinizi tarif edin" (placeholder: "profesyonel erkek yazilimci, gozluk, sakalli")
  - "Olustur" butonu
  - Yukleniyor animasyonu (spinner)
  - Sonuc gorseli on izleme + "Kullan" butonu

**Hakkimda Ayarlari:**
- Tanitim metni (textarea)
- Yetenekler (virgule ayrilmis text input, her biri chip/tag olarak gosterilir)

**Projeler Ayarlari:**
- Proje listesi (her biri icin):
  - Proje adi (text input)
  - Aciklama (textarea)
  - Link (text input)
  - Gorsel URL (text input)
  - **"Proje Gorseli Olustur" butonu** (Fal AI)
    - Proje aciklamasina gore gorsel uretir
    - Tiklayinca kucuk prompt alani gosterilir (proje adi + aciklama otomatik dolar)
    - "Olustur" butonu + yukleniyor + on izleme + "Kullan"
- "Yeni Proje Ekle" butonu

**Deneyim Ayarlari:**
- Deneyim listesi (her biri icin):
  - Sirket adi (text input)
  - Pozisyon (text input)
  - Tarih araligi (text input, serbest format)
  - Aciklama (textarea)
- "Yeni Deneyim Ekle" butonu

**Iletisim Ayarlari:**
- Email adresi (text input)
- Telefon (text input)
- GitHub URL (text input)
- LinkedIn URL (text input)
- Twitter URL (text input)

## Fal AI Entegrasyonu

### API Ayarlari

```javascript
const FAL_KEY = 'KEY_BURAYA_GIRIN';

async function generateImage(prompt) {
  const response = await fetch('https://fal.run/fal-ai/nano-banana-2', {
    method: 'POST',
    headers: {
      'Authorization': `Key ${FAL_KEY}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      prompt: prompt,
      image_size: 'square_hd',
      num_inference_steps: 25,
      guidance_scale: 7.5
    })
  });
  const data = await response.json();
  return data.images[0].url;
}
```

### Kullanim 1: AI Profil Fotografi

Tetikleme: Hero ayarlarindaki "AI Profil Fotografi Olustur" butonu

```javascript
const userDescription = promptInput.value; // kullanicinin tarifi
const prompt = `professional headshot portrait, ${userDescription}, clean background, studio lighting, high quality, photorealistic`;
const imageUrl = await generateImage(prompt);
// imageUrl'yi Hero bileseninin profil gorseli olarak ata
```

UI akisi:
1. Kullanici tarif yazar
2. "Olustur" butonuna tiklar
3. Buton disabled olur, spinner gosterilir, metin "Olusturuluyor..." olur
4. Sonuc gelince: gorselin on izlemesi gosterilir (128x128 yuvarlak)
5. "Kullan" butonuna tiklayinca gorsel Hero'ya uygulanir
6. Hata durumunda: kirmizi uyari mesaji gosterilir, buton tekrar aktif olur

### Kullanim 2: Proje Gorseli

Tetikleme: Proje ayarlarindaki "Proje Gorseli Olustur" butonu

```javascript
const projectDescription = projectDescInput.value;
const prompt = `website screenshot mockup, ${projectDescription}, modern UI, dark theme, browser frame, professional design`;
const imageUrl = await generateImage(prompt);
// imageUrl'yi ilgili proje kartinin gorseli olarak ata
```

UI akisi ayni: prompt alani, olustur butonu, spinner, on izleme, kullan butonu.

## Veri Yapisi

```javascript
const portfolioData = {
  theme: 'green', // 'purple' | 'blue' | 'green' | 'warm'
  sections: [
    {
      id: 'section_1',
      type: 'hero',
      data: {
        title: 'Merhaba, ben Arda',
        subtitle: 'Full-Stack Gelistirici',
        ctaText: 'Iletisime Gec',
        ctaLink: '#iletisim',
        avatarUrl: '' // bos ise placeholder gosterilir
      }
    },
    {
      id: 'section_2',
      type: 'about',
      data: {
        bio: 'Istanbul merkezli bir yazilim gelistiriciyim...',
        skills: ['React', 'Node.js', 'Python', 'PostgreSQL', 'Docker']
      }
    },
    {
      id: 'section_3',
      type: 'projects',
      data: {
        items: [
          {
            name: 'E-Ticaret Platformu',
            description: 'React ve Node.js ile gelistirilmis...',
            link: 'https://github.com',
            imageUrl: ''
          }
          // ...
        ]
      }
    },
    {
      id: 'section_4',
      type: 'experience',
      data: {
        items: [
          {
            company: 'Tech Startup',
            position: 'Senior Frontend Developer',
            period: '2022 - Devam Ediyor',
            description: 'React ve TypeScript ile...'
          }
          // ...
        ]
      }
    },
    {
      id: 'section_5',
      type: 'contact',
      data: {
        email: 'arda@example.com',
        phone: '+90 555 123 4567',
        github: 'https://github.com/arda',
        linkedin: 'https://linkedin.com/in/arda',
        twitter: ''
      }
    }
  ]
};
```

## "Kodu Indir" Islevi

Sayfanin sag ust kosesinde sabit bir "Kodu Indir" butonu (vurgu renkli).

Tiklayinca:
1. `portfolioData` iceriginden bagimsiz, calisir bir HTML dosyasi olusturulur
2. Olusturulan HTML dark temalı, responsive, DM Sans fontlu olur
3. Tum CSS inline olur
4. Gorsel URL'leri oldugu gibi kullanilir (harici linkler)
5. Dosya `portfolio.html` olarak indirilir (`Blob` + `URL.createObjectURL` + `a.click()`)
6. Indirilen dosya kendi basina acilabilir ve duzenleyicideki on izleme ile ayni gorunur

## CSS Detaylari

- Sol ve sag paneller: `background: #141414`, `border-right` veya `border-left: 1px solid #262626`
- Orta panel: `background: #0a0a0a`
- Bilesen kartlari (sol panel): `background: #1a1a1a`, `border-radius: 8px`, `padding: 12px`, hover'da `border: 1px solid [vurgu-rengi]`
- Input/textarea: `background: #1a1a1a`, `border: 1px solid #333`, `color: #e5e5e5`, `border-radius: 6px`, focus'ta `border-color: [vurgu-rengi]`
- Butonlar (birincil): `background: [vurgu-rengi]`, `color: white`, `border-radius: 8px`, `font-weight: 600`
- Butonlar (ikincil): `background: transparent`, `border: 1px solid #333`, `color: #e5e5e5`
- Scrollbar: ince, koyu tema ile uyumlu (`::-webkit-scrollbar` ile)
- Gecis animasyonlari: `transition: all 0.2s ease` genel olarak

## Responsive Davranis

Bu bir masaustu aracı oldugundan tam responsive olmasi gerekmez. Ancak:
- Minimum genislik: `1024px`
- Paneller `overflow-y: auto` ile kaydirılabilir
- Orta panel esnek genislikte

## Hata Yonetimi

- Fal AI API hatasi: Kullaniciya "Gorsel olusturulamadi. API anahtarinizi kontrol edin." mesaji gosterilir
- Bos alanlar: Varsayilan degerler kullanilir, bos birakilabilir
- Indirme: Hicbir bilesen yoksa "En az bir bilesen ekleyin" uyarisi gosterilir

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

