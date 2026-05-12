import React, { useState, useEffect } from 'react';
import './SplashScreenLoading.css';

/**
 * SplashScreenLoading - React Component
 * Komponen splash screen loading dengan animasi spinner melingkar
 * Auto-hide setelah 3 detik dengan transisi fade out
 */
const SplashScreenLoading = ({ duration = 3000, onComplete = () => {} }) => {
  const [isVisible, setIsVisible] = useState(true);
  const [isFadingOut, setIsFadingOut] = useState(false);

  useEffect(() => {
    // Timer untuk mulai fade out sebelum benar-benar hilang
    const fadeOutTimer = setTimeout(() => {
      setIsFadingOut(true);
    }, duration - 300); // Mulai fade 300ms sebelum duration selesai

    // Timer untuk benar-benar menyembunyikan loading
    const hideTimer = setTimeout(() => {
      setIsVisible(false);
      onComplete(); // Callback ketika loading selesai
    }, duration);

    // Cleanup timers
    return () => {
      clearTimeout(fadeOutTimer);
      clearTimeout(hideTimer);
    };
  }, [duration, onComplete]);

  // Jika sudah tidak visible, jangan render
  if (!isVisible) {
    return null;
  }

  return (
    <div className={`splash-screen-overlay ${isFadingOut ? 'fade-out' : ''}`}>
      <div className="splash-screen-content">
        {/* Logo Container */}
        <div className="logo-container">
          {/* Outer Rotating Circle */}
          <div className="outer-circle rotating-border"></div>

          {/* Inner Logo */}
          <div className="logo-box">
            <div className="logo-icon">
              <svg
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="2"
              >
                <path d="M10 12H3L5.64 5.64M10 12h11l-2.64 6.36M10 12v-2M14 16v2M10 20h4" />
              </svg>
            </div>
          </div>
        </div>

        {/* Text Section */}
        <div className="loading-text">
          <h1>TRACKLY</h1>
          <p>Tracking Pengiriman Real-Time</p>
        </div>

        {/* Spinner Loading */}
        <div className="spinner-container">
          <div className="spinner-ring rotating-spinner"></div>
          <div className="spinner-center"></div>
        </div>
      </div>
    </div>
  );
};

export default SplashScreenLoading;
