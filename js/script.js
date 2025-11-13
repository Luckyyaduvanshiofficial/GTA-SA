/**
 * GTA San Andreas Landing Page - Main JavaScript
 * Lightweight vanilla JS for lightbox, mirror selector, and interactive features
 * Progressive enhancement: page works without JavaScript
 */

(function() {
    'use strict';

    // ================================================================
    // UTILITY FUNCTIONS
    // ================================================================

    /**
     * Copy text to clipboard
     */
    function copyToClipboard(text) {
        if (navigator.clipboard && navigator.clipboard.writeText) {
            return navigator.clipboard.writeText(text)
                .then(() => true)
                .catch(() => false);
        } else {
            // Fallback for older browsers
            const textarea = document.createElement('textarea');
            textarea.value = text;
            textarea.style.position = 'fixed';
            textarea.style.opacity = '0';
            document.body.appendChild(textarea);
            textarea.select();
            try {
                document.execCommand('copy');
                document.body.removeChild(textarea);
                return Promise.resolve(true);
            } catch (err) {
                document.body.removeChild(textarea);
                return Promise.resolve(false);
            }
        }
    }

    /**
     * Show temporary notification
     */
    function showNotification(message, type = 'success') {
        const notification = document.createElement('div');
        notification.textContent = message;
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 1rem 1.5rem;
            background: ${type === 'success' ? '#10b981' : '#ef4444'};
            color: white;
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            z-index: 9999;
            animation: slideIn 0.3s ease-out;
        `;
        document.body.appendChild(notification);

        setTimeout(() => {
            notification.style.animation = 'slideOut 0.3s ease-out';
            setTimeout(() => document.body.removeChild(notification), 300);
        }, 3000);
    }

    // Add animation styles
    if (!document.getElementById('notification-styles')) {
        const style = document.createElement('style');
        style.id = 'notification-styles';
        style.textContent = `
            @keyframes slideIn {
                from { transform: translateX(400px); opacity: 0; }
                to { transform: translateX(0); opacity: 1; }
            }
            @keyframes slideOut {
                from { transform: translateX(0); opacity: 1; }
                to { transform: translateX(400px); opacity: 0; }
            }
        `;
        document.head.appendChild(style);
    }

    // ================================================================
    // DOWNLOAD MIRROR SELECTOR
    // ================================================================

    function initMirrorSelector() {
        const mirrorButtons = document.getElementById('mirrorButtons');
        const downloadInfo = document.getElementById('downloadInfo');
        const downloadButton = document.getElementById('downloadButton');
        const fileSize = document.getElementById('fileSize');
        const lastUpdated = document.getElementById('lastUpdated');
        const checksumValue = document.getElementById('checksumValue');
        const copyChecksum = document.getElementById('copyChecksum');

        if (!window.downloadMirrors || !mirrorButtons) return;

        let selectedMirror = null;

        // Create mirror buttons
        window.downloadMirrors.forEach((mirror, index) => {
            const button = document.createElement('button');
            button.className = 'btn-mirror';
            button.textContent = mirror.name;
            button.setAttribute('data-mirror-index', index);
            button.addEventListener('click', () => selectMirror(index));
            mirrorButtons.appendChild(button);
        });

        // Select mirror
        function selectMirror(index) {
            selectedMirror = window.downloadMirrors[index];

            // Update active button
            mirrorButtons.querySelectorAll('.btn-mirror').forEach((btn, i) => {
                btn.classList.toggle('active', i === index);
            });

            // Update download info
            fileSize.textContent = selectedMirror.size;
            lastUpdated.textContent = selectedMirror.updated;
            checksumValue.textContent = selectedMirror.checksum;
            downloadButton.href = selectedMirror.url;

            // Show download info
            downloadInfo.style.display = 'block';
            downloadInfo.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        }

        // Copy checksum
        if (copyChecksum) {
            copyChecksum.addEventListener('click', async () => {
                if (!selectedMirror) return;
                
                const success = await copyToClipboard(selectedMirror.checksum);
                if (success) {
                    showNotification('Checksum copied to clipboard!');
                    copyChecksum.textContent = '✓ Copied';
                    setTimeout(() => {
                        copyChecksum.innerHTML = '<svg width="16" height="16" fill="currentColor" viewBox="0 0 20 20"><path d="M8 3a1 1 0 011-1h2a1 1 0 110 2H9a1 1 0 01-1-1z"/><path d="M6 3a2 2 0 00-2 2v11a2 2 0 002 2h8a2 2 0 002-2V5a2 2 0 00-2-2 3 3 0 01-3 3H9a3 3 0 01-3-3z"/></svg> Copy';
                    }, 2000);
                } else {
                    showNotification('Failed to copy checksum', 'error');
                }
            });
        }

        // Auto-select first mirror
        if (window.downloadMirrors.length > 0) {
            selectMirror(0);
        }
    }

    // ================================================================
    // BEFORE/AFTER COMPARISON SLIDERS
    // ================================================================

    function initComparisonSliders() {
        const sliders = document.querySelectorAll('.before-after-container');
        
        sliders.forEach(container => {
            const slider = container.querySelector('.slider-control');
            const afterImage = container.querySelector('.before-after-image.after');
            
            if (!slider || !afterImage) return;

            slider.addEventListener('input', (e) => {
                const value = e.target.value;
                afterImage.style.clipPath = `inset(0 ${100 - value}% 0 0)`;
            });

            // Set initial position
            afterImage.style.clipPath = 'inset(0 50% 0 0)';
        });
    }

    // ================================================================
    // LIGHTBOX GALLERY
    // ================================================================

    function initLightbox() {
        const lightbox = document.getElementById('lightbox');
        const lightboxImage = document.getElementById('lightboxImage');
        const closeBtn = lightbox?.querySelector('.lightbox-close');
        const prevBtn = lightbox?.querySelector('.lightbox-prev');
        const nextBtn = lightbox?.querySelector('.lightbox-next');
        const screenshots = document.querySelectorAll('.screenshot-item');

        if (!lightbox || screenshots.length === 0) return;

        let currentIndex = 0;
        const images = Array.from(screenshots).map(item => {
            const img = item.querySelector('img');
            return {
                src: img.src,
                alt: img.alt
            };
        });

        // Open lightbox
        screenshots.forEach((item, index) => {
            item.addEventListener('click', () => {
                currentIndex = index;
                showImage(currentIndex);
                lightbox.style.display = 'flex';
                document.body.style.overflow = 'hidden';
            });

            // Keyboard accessibility
            item.setAttribute('tabindex', '0');
            item.setAttribute('role', 'button');
            item.addEventListener('keydown', (e) => {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    item.click();
                }
            });
        });

        // Show image
        function showImage(index) {
            if (index < 0 || index >= images.length) return;
            currentIndex = index;
            lightboxImage.src = images[index].src;
            lightboxImage.alt = images[index].alt;
        }

        // Close lightbox
        function closeLightbox() {
            lightbox.style.display = 'none';
            document.body.style.overflow = '';
        }

        if (closeBtn) {
            closeBtn.addEventListener('click', closeLightbox);
        }

        // Click outside image to close
        lightbox.addEventListener('click', (e) => {
            if (e.target === lightbox) {
                closeLightbox();
            }
        });

        // Previous image
        if (prevBtn) {
            prevBtn.addEventListener('click', () => {
                currentIndex = (currentIndex - 1 + images.length) % images.length;
                showImage(currentIndex);
            });
        }

        // Next image
        if (nextBtn) {
            nextBtn.addEventListener('click', () => {
                currentIndex = (currentIndex + 1) % images.length;
                showImage(currentIndex);
            });
        }

        // Keyboard navigation
        document.addEventListener('keydown', (e) => {
            if (lightbox.style.display !== 'flex') return;

            switch (e.key) {
                case 'Escape':
                    closeLightbox();
                    break;
                case 'ArrowLeft':
                    prevBtn?.click();
                    break;
                case 'ArrowRight':
                    nextBtn?.click();
                    break;
            }
        });
    }

    // ================================================================
    // SMOOTH SCROLL FOR ANCHOR LINKS
    // ================================================================

    function initSmoothScroll() {
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function(e) {
                const href = this.getAttribute('href');
                if (href === '#') return;

                const target = document.querySelector(href);
                if (target) {
                    e.preventDefault();
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                    
                    // Update URL without jumping
                    history.pushState(null, '', href);
                }
            });
        });
    }

    // ================================================================
    // LAZY LOADING IMAGES
    // ================================================================

    function initLazyLoading() {
        const images = document.querySelectorAll('img[loading="lazy"]');
        
        if ('IntersectionObserver' in window) {
            const imageObserver = new IntersectionObserver((entries, observer) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const img = entry.target;
                        img.classList.add('loaded');
                        observer.unobserve(img);
                    }
                });
            });

            images.forEach(img => imageObserver.observe(img));
        } else {
            // Fallback: just load all images
            images.forEach(img => img.classList.add('loaded'));
        }
    }

    // ================================================================
    // ANALYTICS OPT-OUT
    // ================================================================

    function initAnalyticsOptOut() {
        const optOutLink = document.getElementById('optOutAnalytics');
        
        if (optOutLink) {
            optOutLink.addEventListener('click', (e) => {
                e.preventDefault();
                
                // Set opt-out cookie
                document.cookie = 'ga-disable=true; path=/; max-age=31536000; SameSite=Lax';
                
                // Disable GA if it's loaded
                if (window.gtag) {
                    window['ga-disable-YOUR_GA4_MEASUREMENT_ID'] = true;
                }
                
                showNotification('You have opted out of analytics tracking.');
            });
        }
    }

    // ================================================================
    // FAQ ACCORDION (OPTIONAL ENHANCEMENT)
    // ================================================================

    function initFAQAccordion() {
        const faqItems = document.querySelectorAll('.faq-item');
        
        faqItems.forEach(item => {
            const question = item.querySelector('.faq-question');
            const answer = item.querySelector('.faq-answer');
            
            if (!question || !answer) return;

            // Add click handler for keyboard accessibility
            question.style.cursor = 'pointer';
            question.setAttribute('tabindex', '0');
            question.setAttribute('role', 'button');
            question.setAttribute('aria-expanded', 'true');
        });
    }

    // ================================================================
    // SCROLL-TO-TOP BUTTON (OPTIONAL)
    // ================================================================

    function initScrollToTop() {
        // Create scroll-to-top button
        const scrollBtn = document.createElement('button');
        scrollBtn.innerHTML = '↑';
        scrollBtn.className = 'scroll-to-top';
        scrollBtn.style.cssText = `
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            width: 3rem;
            height: 3rem;
            border-radius: 50%;
            background: #10b981;
            color: white;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s, visibility 0.3s;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            z-index: 1000;
        `;
        scrollBtn.setAttribute('aria-label', 'Scroll to top');
        document.body.appendChild(scrollBtn);

        // Show/hide on scroll
        window.addEventListener('scroll', () => {
            if (window.pageYOffset > 300) {
                scrollBtn.style.opacity = '1';
                scrollBtn.style.visibility = 'visible';
            } else {
                scrollBtn.style.opacity = '0';
                scrollBtn.style.visibility = 'hidden';
            }
        });

        // Scroll to top on click
        scrollBtn.addEventListener('click', () => {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    }

    // ================================================================
    // INITIALIZATION
    // ================================================================

    function init() {
        // Wait for DOM to be ready
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', init);
            return;
        }

        // Initialize all features
        initMirrorSelector();
        initComparisonSliders();
        initLightbox();
        initSmoothScroll();
        initLazyLoading();
        initAnalyticsOptOut();
        initFAQAccordion();
        initScrollToTop();

        // Log successful initialization (remove in production)
        console.log('GTA San Andreas Landing Page initialized');
    }

    // Start initialization
    init();

})();
