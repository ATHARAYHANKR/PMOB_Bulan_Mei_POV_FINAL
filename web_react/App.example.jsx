import React, { useState } from 'react';
import SplashScreenLoading from './components/SplashScreenLoading';

/**
 * Contoh Penggunaan SplashScreenLoading Component
 */
function App() {
  const [showSplash, setShowSplash] = useState(true);

  const handleSplashComplete = () => {
    console.log('Splash screen selesai!');
    // Di sini Anda bisa melakukan inisialisasi atau navigasi
  };

  return (
    <div className="App">
      {/* Splash Screen Loading - Tampil 3 detik */}
      {showSplash && (
        <SplashScreenLoading
          duration={3000}
          onComplete={() => {
            setShowSplash(false);
            handleSplashComplete();
          }}
        />
      )}

      {/* Main Content */}
      {!showSplash && (
        <div className="main-content">
          <h1>Selamat Datang di TRACKLY</h1>
          <p>Aplikasi Tracking Pengiriman Real-Time</p>
          {/* Konten aplikasi Anda di sini */}
        </div>
      )}
    </div>
  );
}

export default App;
