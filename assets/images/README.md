# Image Assets

This directory contains all image assets for the GTA San Andreas landing page.

## Required Images

### Favicons (`favicons/`)
- `favicon-16x16.png` - 16x16px favicon
- `favicon-32x32.png` - 32x32px favicon
- `apple-touch-icon.png` - 180x180px iOS icon
- `favicon-192x192.png` - 192x192px PWA icon
- `favicon-512x512.png` - 512x512px PWA icon

**Generate favicons:** Use [favicon.io](https://favicon.io/) or similar tools.

---

### Screenshots (`images/`)

#### Before/After Comparison Images
- `before-1.webp` - Original graphics (1920x1080, optimized webp)
- `after-1.webp` - Enhanced graphics (1920x1080, optimized webp)
- `before-2.webp` - Original taxi (1920x1080, optimized webp)
- `after-2.webp` - Rolls-Royce taxi mod (1920x1080, optimized webp)
- `before-3.webp` - Original environment (1920x1080, optimized webp)
- `after-3.webp` - Enhanced environment (1920x1080, optimized webp)

#### Gallery Screenshots
- `screenshot-1.webp` - Gameplay HD graphics (1920x1080, < 150KB)
- `screenshot-2.webp` - Rolls-Royce taxi in action (1920x1080, < 150KB)
- `screenshot-3.webp` - Enhanced environment (1920x1080, < 150KB)
- `screenshot-4.webp` - Night time with improved lighting (1920x1080, < 150KB)
- `screenshot-5.webp` - Sports car mods (1920x1080, < 150KB)
- `screenshot-6.webp` - Mission gameplay (1920x1080, < 150KB)

#### Social Media
- `og-image.jpg` - Open Graph image for social sharing (1200x630, < 200KB)

---

## Image Optimization Guidelines

### File Format
- Use **WebP** for all screenshots (90-95% quality)
- Use **PNG** for favicons and icons
- Use **JPG** for OG image

### Size Limits
- Each screenshot: **< 150KB**
- OG image: **< 200KB**
- Total page images: **< 1.2MB**

### Dimensions
- Screenshots: **1920x1080** (Full HD)
- OG image: **1200x630** (Facebook/Twitter standard)
- Favicons: Follow standard sizes above

### Optimization Tools
- **Online:** [Squoosh.app](https://squoosh.app), [TinyPNG](https://tinypng.com)
- **CLI:** `cwebp`, `imagemagick`
- **Batch:** Use scripts in `/scripts/optimize-images.sh`

### Example Optimization
```bash
# Convert PNG to WebP
cwebp -q 90 input.png -o output.webp

# Resize and optimize
convert input.png -resize 1920x1080 -quality 90 output.webp
```

---

## Creating Placeholder Images

If you don't have actual screenshots yet, create placeholder images:

### Online Generators
- [Placeholder.com](https://placeholder.com/)
- [Placehold.co](https://placehold.co/)

### Quick Placeholders
```bash
# Using ImageMagick
convert -size 1920x1080 xc:#667eea -pointsize 72 -fill white \
  -draw "text 800,540 'Screenshot 1'" screenshot-1.jpg
```

---

## Alt Text Guidelines

Every image must have descriptive alt text for SEO and accessibility:

✅ **Good:** "GTA San Andreas modded gameplay showing HD graphics and new vehicle mods in Los Santos"

❌ **Bad:** "screenshot1" or "image"

---

## Current Status

⚠️ **Placeholder images needed** - Replace with actual mod pack screenshots before deployment.

To add images:
1. Place images in this directory following naming convention
2. Optimize using tools listed above
3. Verify total page weight < 1.5MB
4. Test on mobile connection

---

Last updated: November 2025
