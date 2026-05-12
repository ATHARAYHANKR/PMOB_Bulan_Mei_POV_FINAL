# React Splash Screen Loading Component

Komponen React untuk splash screen loading dengan animasi spinner melingkar yang elegan.

## 📋 Fitur

✅ **Spinner berbentuk lingkaran** - Animated circular loading
✅ **Animasi CSS** - Smooth rotation dan transitions
✅ **Fullscreen overlay** - Menutupi seluruh viewport
✅ **Auto-hide 3 detik** - Hilang otomatis dengan fade out
✅ **State management** - Kontrol dengan React hooks
✅ **Transisi fade out** - 300ms smooth fade sebelum hilang
✅ **Responsive design** - Mobile, tablet, desktop optimal
✅ **Callback support** - Execute code saat loading selesai

## 🚀 Instalasi

1. Copy file-file ke project React Anda:
   - `SplashScreenLoading.jsx` (Component)
   - `SplashScreenLoading.css` (Styles)

2. Import component di App.jsx

## 💻 Penggunaan Dasar

```jsx
import SplashScreenLoading from './components/SplashScreenLoading';

function App() {
  const [showSplash, setShowSplash] = useState(true);

  return (
    <>
      {showSplash && (
        <SplashScreenLoading
          duration={3000}
          onComplete={() => setShowSplash(false)}
        />
      )}
      {!showSplash && <MainContent />}
    </>
  );
}
```

## ⚙️ Props

| Prop | Type | Default | Deskripsi |
|------|------|---------|-----------|
| `duration` | number | 3000 | Durasi loading dalam ms |
| `onComplete` | function | () => {} | Callback setelah loading selesai |

## 🎨 Animasi yang Disertakan

1. **fadeIn** - Overlay fade in saat mount
2. **slideUp** - Content slide up dengan bounce
3. **scaleIn** - Outer circle scale dengan fade
4. **scaleUp** - Logo box scale up with elastic
5. **fadeInDelay** - Text & spinner fade with delay
6. **rotate** - Outer circle rotating 4s
7. **spin** - Spinner ring rotating 2s

## 🔧 Customization

### Mengubah durasi
```jsx
<SplashScreenLoading duration={5000} /> // 5 detik
```

### Mengubah warna
Edit CSS variables di `SplashScreenLoading.css`:
```css
--primary-color: #5c3317;
--secondary-color: #a0673a;
--light-bg: #fdf6ec;
```

### Mengubah logo/icon
Ganti SVG di component atau gunakan image:
```jsx
<img src="/logo.png" alt="Logo" />
```

## 📱 Responsive Breakpoints

- **Desktop**: 1024px+ (full size)
- **Tablet**: 768px - 1023px (medium)
- **Mobile**: < 768px (optimized)

## ⏱️ Loading Duration Presets

```jsx
// 3 detik (default)
<SplashScreenLoading duration={3000} />

// 5 detik
<SplashScreenLoading duration={5000} />

// 15 detik (sesuai Flutter)
<SplashScreenLoading duration={15000} />
```

## 🎯 Advanced Usage dengan Async Operation

```jsx
function App() {
  const [showSplash, setShowSplash] = useState(true);

  const handleSplashComplete = async () => {
    try {
      // Initialize app data
      await initializeApp();
      setShowSplash(false);
    } catch (error) {
      console.error('Initialization failed', error);
    }
  };

  return (
    <SplashScreenLoading
      duration={3000}
      onComplete={handleSplashComplete}
    />
  );
}
```

## 📦 Dependencies

- React 16.8+ (untuk hooks)
- CSS3 (untuk animations)

## 🎬 Animation Timeline

```
0ms     - Overlay & content fade in
200ms   - Outer circle scales in + rotates
400ms   - Logo scales up
400ms   - Text & spinner fade in
2700ms  - Start fade out (3000 - 300)
3000ms  - Complete hide & trigger callback
```

## 🐛 Browser Support

- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+
- Mobile browsers (iOS Safari 14+, Chrome Android)

## 📝 Notes

- Component auto-unmounts setelah duration
- Timers di-cleanup dengan useEffect return
- Smooth 300ms fade out transition
- Prevent pointer events saat fade out
- Z-index 9999 untuk overlap semua content

---

**Contoh penggunaan lengkap**: Lihat `App.example.jsx`
