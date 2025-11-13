# GTA San Andreas Download — Modded Edition Landing Page

**Fast, mobile-optimized, SEO-friendly landing page for gta-san-andreas.in**

## 🚀 Features

- **Ultra-lightweight**: Total page weight < 1.5MB (optimized for low-end devices)
- **SEO-optimized**: Targets "gta san andreas download" keyword
- **Mobile-first**: Responsive design for all screen sizes
- **Progressive enhancement**: Works with JavaScript disabled
- **Legal compliance**: Clear disclaimers, no distribution of original game files

## 📦 Project Structure

```
.
├── index.html              # Main landing page
├── css/
│   └── styles.css          # Compiled Tailwind CSS
├── js/
│   └── script.js           # Minimal vanilla JavaScript
├── assets/
│   ├── images/             # Screenshot gallery (webp format)
│   └── favicons/           # Site icons
├── scripts/
│   ├── install.ps1         # PowerShell installer for Windows
│   └── install.sh          # Bash installer for Linux/Mac
├── .github/
│   └── workflows/
│       └── link-health.yml # CI for mirror link health checks
├── sitemap.xml             # SEO sitemap
├── robots.txt              # Search engine directives
├── package.json            # Tailwind CLI configuration
└── tailwind.config.js      # Tailwind configuration
```

## 🛠️ Setup & Development

### Prerequisites
- Node.js 16+ (for Tailwind CLI)
- Git

### Installation

1. Clone the repository:
```bash
git clone <your-repo-url>
cd "GTA Landing page"
```

2. Install dependencies:
```bash
npm install
```

3. Build CSS:
```bash
npm run build:css
```

4. For development with auto-rebuild:
```bash
npm run watch:css
```

5. Open `index.html` in your browser or use a local server:
```bash
npx serve .
```

## 📤 Deployment

### GitHub Pages

1. Build the CSS:
```bash
npm run build:css
```

2. Commit and push:
```bash
git add .
git commit -m "Deploy landing page"
git push origin main
```

3. Enable GitHub Pages:
   - Go to Settings → Pages
   - Select branch: `main`
   - Select folder: `/ (root)`
   - Save

Your site will be live at `https://<username>.github.io/<repo-name>/`

### Netlify

1. Build the CSS:
```bash
npm run build:css
```

2. Deploy:
   - Connect your Git repository to Netlify
   - Build command: `npm run build:css`
   - Publish directory: `.` (root)

Or use Netlify CLI:
```bash
npm install -g netlify-cli
netlify deploy --prod
```

### Custom Domain Setup

For `gta-san-andreas.in`:

1. **GitHub Pages**:
   - Add a `CNAME` file with your domain
   - Configure DNS A records to GitHub Pages IPs

2. **Netlify**:
   - Go to Domain settings → Add custom domain
   - Configure DNS as instructed

## 🔐 Updating Download Mirrors

Edit `index.html` and update the mirror data in the `<script>` section:

```javascript
const mirrors = [
  {
    name: 'Google Drive',
    url: 'https://drive.google.com/file/d/YOUR_FILE_ID/view',
    size: '1.2 GB',
    checksum: 'YOUR_SHA256_CHECKSUM_HERE',
    updated: '2025-11-13'
  },
  // Add more mirrors...
];
```

### Generating SHA-256 Checksums

**Windows (PowerShell)**:
```powershell
Get-FileHash -Algorithm SHA256 "modpack.zip" | Select-Object Hash
```

**Linux/Mac**:
```bash
sha256sum modpack.zip
```

## 🔍 SEO Optimization

### Current Optimizations
- Semantic HTML5 structure
- JSON-LD structured data (SoftwareApplication)
- Open Graph and Twitter Card meta tags
- Optimized title and meta description
- Canonical URL pointing to .in domain
- Hreflang tags for international targeting
- Image alt attributes with keywords
- Fast loading time (< 1s on desktop)

### Monitoring
- Use Google Search Console to monitor performance
- Check PageSpeed Insights regularly
- Monitor Core Web Vitals

## 📊 Analytics Setup

Replace the placeholder in `index.html`:

```html
<!-- Replace YOUR_GA4_MEASUREMENT_ID -->
<script async src="https://www.googletagmanager.com/gtag/js?id=YOUR_GA4_MEASUREMENT_ID"></script>
```

## 💰 Adding AdSense

Ad slots are pre-configured with `defer` loading. Replace placeholders:

```html
<!-- Replace YOUR_ADSENSE_CLIENT_ID -->
<ins class="adsbygoogle" data-ad-client="YOUR_ADSENSE_CLIENT_ID"></ins>
```

## ⚖️ Legal Compliance

**IMPORTANT**: This landing page includes mandatory legal disclaimers:

1. **Download section**: Visible notice that users need a legal copy of GTA San Andreas
2. **Footer**: Links to privacy policy and terms of service (create these pages)
3. **No original game files**: Only mod pack files and installers are distributed

### Required Actions
- Create `privacy.html` with your privacy policy
- Create `terms.html` with terms of service
- Ensure your mod pack does NOT include original Rockstar game files
- Keep disclaimer visible and clear

## 🧪 Testing Checklist

Before deployment:

- [ ] Page loads in < 1s on desktop
- [ ] Total page weight < 1.5MB
- [ ] All download links work
- [ ] Checksums are correct
- [ ] Legal disclaimers visible
- [ ] Mobile responsive (test on multiple devices)
- [ ] All images have alt text
- [ ] Keyboard navigation works
- [ ] Color contrast >= 4.5:1
- [ ] Works with JavaScript disabled
- [ ] No console errors
- [ ] SEO meta tags present
- [ ] JSON-LD validates (use Google Rich Results Test)

## 🐛 Troubleshooting

### CSS not updating?
```bash
npm run build:css
# Clear browser cache (Ctrl+F5)
```

### Mirror links not working?
- Check the GitHub Actions workflow for link health status
- Update broken links in the mirrors array
- Commit and redeploy

### Page loading slowly?
- Compress images further (use tinypng.com or squoosh.app)
- Ensure CSS is minified
- Check Netlify/GitHub Pages CDN is working

## 📝 Maintenance

### Regular Tasks
1. **Weekly**: Check mirror link health via GitHub Actions
2. **Monthly**: Update checksums if mod pack is updated
3. **Quarterly**: Review and update FAQ section
4. **As needed**: Add new screenshots to gallery

### Version Updates
When releasing a new mod pack version:
1. Upload to mirrors
2. Generate new checksums
3. Update `index.html` with new version number, date, and checksums
4. Update installer scripts if needed
5. Test all download links
6. Deploy

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This landing page code is open source. The mod pack itself is subject to separate licensing.

**Note**: GTA San Andreas is owned by Rockstar Games. This project does not distribute original game files.

## 🔗 Links

- Global site: [gta-san-andreas.one](https://gta-san-andreas.one)
- India site: [gta-san-andreas.in](https://gta-san-andreas.in)
- Support: contact@gta-san-andreas.in

---

**Last Updated**: November 2025
