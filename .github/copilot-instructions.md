# Copilot Instructions: GTA San Andreas Landing Page

## Project Overview

Single-page landing site for GTA San Andreas mod pack distribution, targeting "gta san andreas download" keyword with India-focused SEO. **Performance-first architecture**: <1.5MB page weight, <1s load time, optimized for low-end devices and 2G/3G networks.

## Architecture & Key Patterns

### Build System: Tailwind CLI (No Framework)
- **CSS compilation**: `npm run build:css` transforms `css/styles.css` → `css/styles.min.css`
- **Critical CSS**: Inline in `<head>` of `index.html` for instant first paint (hero section only)
- **Watch mode**: `npm run watch:css` for development
- ⚠️ **Always rebuild CSS after editing** `css/styles.css` or `tailwind.config.js`

### Vanilla JavaScript Architecture (`js/script.js`)
- **Progressive enhancement**: All features are optional enhancements - page fully functional without JS
- **IIFE pattern**: Self-contained module with no global pollution
- **Key modules**:
  - `initMirrorSelector()`: Downloads UI with checksum verification
  - `initLightbox()`: Gallery with keyboard nav (←/→/Esc)
  - `initComparisonSliders()`: Before/after image sliders
  - `copyToClipboard()`: Utility with legacy fallback for older browsers

### Data-Driven Download Mirrors
Download mirrors are defined as **inline JSON** at bottom of `index.html`:
```javascript
const mirrors = [
  { name: 'Google Drive', url: '...', size: '1.2 GB', checksum: 'SHA256...', updated: '2025-11-13' }
];
window.downloadMirrors = mirrors;
```
- **Why inline?** No build step, easy content updates, SEO-friendly
- **When editing**: Update URL, checksum, size, and date together
- **Checksum generation**: PowerShell `Get-FileHash -Algorithm SHA256` or Linux `sha256sum`

## Critical Development Workflows

### Making Style Changes
```powershell
# 1. Edit css/styles.css (uses Tailwind @layer components)
# 2. Rebuild minified CSS
npm run build:css
# 3. Hard refresh browser (Ctrl+F5) to bypass cache
```

### Adding New Interactive Features
1. Add HTML structure to `index.html`
2. Create `init[FeatureName]()` function in `js/script.js`
3. Call from main `init()` function at bottom
4. **Always check**: Feature degrades gracefully if JS disabled

### Updating Download Links
1. Edit `mirrors` array at bottom of `index.html`
2. Generate new checksums: `Get-FileHash -Algorithm SHA256 "file.zip"`
3. Update all fields: `url`, `size`, `checksum`, `updated`
4. Test mirror selector UI works after changes

### Adding Images
1. Place in `assets/images/` as **WebP format** (< 150KB target)
2. Add to `index.html` with `loading="lazy"` attribute
3. **Always include** descriptive `alt` text for SEO
4. Optimization tools: Squoosh.app, TinyPNG, `cwebp` CLI

## Project-Specific Conventions

### SEO Optimization Patterns
- **Dual domain strategy**: `.in` (India) + `.one` (global) with hreflang tags
- **JSON-LD structured data**: `SoftwareApplication` schema in `<head>`
- **Canonical URL**: Always points to `gta-san-andreas.in`
- **Keywords**: "gta san andreas download" in title, meta, H1, and naturally throughout content

### Image Naming Convention
```
before-1.webp, after-1.webp   # Comparison sliders
screenshot-1.webp to 6.webp   # Gallery
og-image.jpg                  # Social sharing (1200x630)
favicon-32x32.png, etc.       # Icons
```

### Color Palette (Tailwind Config)
- **Primary green**: `#10b981` (download buttons, success states)
- **Purple gradient**: `#667eea` → `#764ba2` (hero background)
- **Gray scale**: Tailwind defaults for text and backgrounds

### Responsive Breakpoints Strategy
- **Mobile-first**: Base styles for 320px+ (iPhone SE)
- **sm:** 640px (phones landscape)
- **md:** 768px (tablets)
- **lg:** 1024px+ (desktops)
- Test at: 320px, 375px, 768px, 1024px

## Integration Points

### External Dependencies (CDN/APIs)
- **Tailwind CDN**: Used in development only (`<script src="https://cdn.tailwindcss.com">`), not in production
- **Google Analytics**: Replace `YOUR_GA4_MEASUREMENT_ID` placeholder in `index.html` before deploy
- **AdSense** (optional): Replace `YOUR_ADSENSE_CLIENT_ID` if monetizing

### GitHub Actions: Link Health Monitoring
- **Workflow**: `.github/workflows/link-health.yml`
- **Schedule**: Daily at 9 AM UTC
- **Function**: Checks all mirror URLs return HTTP 200
- **On failure**: Creates GitHub issue automatically
- **Manual trigger**: Actions tab → Run workflow

## Pre-Deployment Requirements

### Content Placeholders to Replace
1. All images: `assets/images/*.webp` (currently placeholder paths)
2. Download mirrors: `url`, `checksum` fields in `index.html` mirrors array
3. Analytics ID: `YOUR_GA4_MEASUREMENT_ID` (2 occurrences in `index.html`)
4. Contact email: `contact@gta-san-andreas.in` in footer
5. Legal pages: Create `privacy.html` and `terms.html`

### Critical Performance Checks
```powershell
# Build production CSS
npm run build:css

# Verify total page weight
# Target: < 1.5MB including all assets
# Check: DevTools Network tab with cache disabled

# PageSpeed Insights
# Score target: 90+ Performance, 100 Accessibility
```

### Testing Checklist (use `DEPLOYMENT_CHECKLIST.md`)
- Mirror selector chooses first mirror by default
- Checksum copy-to-clipboard works
- Before/after sliders respond to input
- Lightbox opens/closes, keyboard arrows work
- All links return 200 status
- Page loads <1s on desktop throttled 3G

## Common Pitfalls

❌ **Editing `styles.min.css` directly** → Changes overwritten by build  
✅ Edit `css/styles.css` then run `npm run build:css`

❌ **Adding large images (>300KB)** → Breaks performance budget  
✅ Compress to WebP <150KB using Squoosh.app

❌ **Forgetting to update checksums** → User downloads fail verification  
✅ Generate fresh checksums: `Get-FileHash -Algorithm SHA256 "file.zip"`

❌ **Breaking progressive enhancement** → Site unusable without JS  
✅ Test with JS disabled (DevTools Settings → Disable JavaScript)

❌ **Using CDN Tailwind in production** → Violates performance goals  
✅ Always deploy compiled `styles.min.css`

## Quick Reference

### File Responsibilities
- `index.html`: All content, SEO meta, inline mirror data
- `js/script.js`: All interactivity (lightbox, sliders, downloads)
- `css/styles.css`: Tailwind components and custom styles
- `tailwind.config.js`: Theme colors, breakpoints
- `package.json`: Build scripts and dependencies
- `DEPLOYMENT_CHECKLIST.md`: 15-step pre-launch verification

### Key Files for SEO
- `sitemap.xml`: Update URLs if adding pages
- `robots.txt`: Search engine crawl rules
- `manifest.json`: PWA configuration for mobile

### Development Server
```powershell
npm run dev  # Serves on http://localhost:3000
```

---

**Last Updated**: 2025-11-13  
**Project Version**: 2.0  
**Performance Budget**: 1.5MB total, <1s load time, 90+ Lighthouse score
