# GTA San Andreas Landing Page - Deployment Checklist

Use this checklist before deploying to production.

## Pre-Deployment Checklist

### 1. Content & Assets
- [ ] All images optimized (< 150KB each, WebP format)
- [ ] Total page weight < 1.5MB
- [ ] All images have descriptive alt text
- [ ] Favicon files present in `assets/favicons/`
- [ ] OG image created (1200x630, < 200KB)

### 2. Download Configuration
- [ ] Mirror URLs updated with actual links
- [ ] SHA-256 checksums generated and verified
- [ ] File sizes accurate
- [ ] Last updated dates current
- [ ] All mirror links tested and working

### 3. SEO & Meta Tags
- [ ] Title optimized: "GTA San Andreas Download — Modded Edition for Low-End PCs"
- [ ] Meta description present and under 160 characters
- [ ] Canonical URL points to gta-san-andreas.in
- [ ] Hreflang tags configured (.in and .one)
- [ ] JSON-LD structured data validated
- [ ] sitemap.xml updated with correct URLs
- [ ] robots.txt configured

### 4. Analytics & Tracking
- [ ] GA4 measurement ID replaced (YOUR_GA4_MEASUREMENT_ID)
- [ ] Analytics opt-out working
- [ ] AdSense client ID replaced (if using ads)
- [ ] Privacy policy created and linked
- [ ] Terms of service created and linked

### 5. Legal & Safety
- [ ] Download disclaimer visible near download section
- [ ] Footer disclaimer present
- [ ] "Requires legal copy" notice clear
- [ ] No original game files included
- [ ] Privacy policy link working
- [ ] Terms of service link working

### 6. Build & Compilation
- [ ] `npm install` completed successfully
- [ ] `npm run build:css` compiled CSS without errors
- [ ] styles.min.css file generated
- [ ] No console errors in browser
- [ ] No broken links on page

### 7. Performance Testing
- [ ] Page loads in < 1 second (desktop, local network)
- [ ] Lighthouse score > 90 for Performance
- [ ] LCP (Largest Contentful Paint) < 2.5s
- [ ] Total Blocking Time < 200ms
- [ ] Cumulative Layout Shift < 0.1
- [ ] Mobile PageSpeed Insights tested

### 8. Functionality Testing
- [ ] Download mirror selector works
- [ ] Checksum copy-to-clipboard works
- [ ] Before/after sliders work
- [ ] Lightbox gallery opens and navigates
- [ ] All anchor links scroll correctly
- [ ] Smooth scrolling enabled
- [ ] Scroll-to-top button appears/works

### 9. Accessibility Testing
- [ ] All images have alt attributes
- [ ] Tab navigation works through all interactive elements
- [ ] Color contrast ratio >= 4.5:1 for text
- [ ] ARIA labels present where needed
- [ ] Keyboard shortcuts work (Esc to close lightbox, arrows to navigate)
- [ ] Screen reader friendly

### 10. Cross-Browser Testing
- [ ] Chrome (latest)
- [ ] Firefox (latest)
- [ ] Safari (latest)
- [ ] Edge (latest)
- [ ] Mobile Safari (iOS)
- [ ] Chrome Mobile (Android)

### 11. Mobile Responsiveness
- [ ] Tested on 320px width (iPhone SE)
- [ ] Tested on 375px width (iPhone 12)
- [ ] Tested on 768px width (iPad)
- [ ] Tested on 1024px+ width (Desktop)
- [ ] All images responsive
- [ ] Text readable at all sizes
- [ ] Buttons easily tappable (min 44px)

### 12. Progressive Enhancement
- [ ] Page works with JavaScript disabled
- [ ] Download links functional without JS
- [ ] Content accessible without CSS
- [ ] Images load with lazy loading
- [ ] Fallbacks for older browsers

### 13. Security
- [ ] All external links use `rel="noopener noreferrer"`
- [ ] No sensitive data in client-side code
- [ ] HTTPS enforced (if deployed)
- [ ] Content Security Policy configured (optional)
- [ ] No mixed content warnings

### 14. GitHub Actions
- [ ] link-health.yml workflow tested
- [ ] Workflow successfully checks mirror links
- [ ] GitHub Actions secrets configured (if needed)
- [ ] Workflow creates issues on failure

### 15. Final Review
- [ ] Spelling and grammar checked
- [ ] All sections complete (Hero, Features, Gallery, Requirements, Install, Download, FAQ, Footer)
- [ ] Contact email working
- [ ] Copyright year current
- [ ] No Lorem Ipsum or placeholder text
- [ ] All TODOs resolved

## Deployment Commands

### GitHub Pages
```powershell
# Build CSS
npm run build:css

# Commit and push
git add .
git commit -m "Deploy: Production-ready landing page"
git push origin main

# Enable in GitHub repo settings
# Settings → Pages → Source: main, / (root)
```

### Netlify
```powershell
# Build
npm run build:css

# Deploy via Netlify CLI
netlify deploy --prod

# Or connect GitHub repo in Netlify dashboard
```

### Custom Domain Setup
```powershell
# Add CNAME file
echo "gta-san-andreas.in" > CNAME

# Configure DNS
# Add A record: @ → GitHub Pages IPs or Netlify IPs
# Add CNAME record: www → <username>.github.io or <netlify-subdomain>.netlify.app
```

## Post-Deployment Checklist

### Immediately After Deploy
- [ ] Visit live URL and verify page loads
- [ ] Test all download links on production
- [ ] Check Google Search Console for indexing
- [ ] Submit sitemap to Google Search Console
- [ ] Test analytics tracking (make a test visit)
- [ ] Check browser console for errors on live site

### Within 24 Hours
- [ ] Monitor analytics for traffic
- [ ] Check for any user-reported issues
- [ ] Verify Google is crawling the site
- [ ] Test on real mobile devices
- [ ] Review PageSpeed Insights for production

### Within 1 Week
- [ ] Check Google Search Console for indexing status
- [ ] Monitor Core Web Vitals in Search Console
- [ ] Review analytics data
- [ ] Check for broken links (use link-health workflow)
- [ ] Verify site appears in Google search results

## Rollback Plan

If issues occur after deployment:

1. **Revert to previous commit:**
   ```powershell
   git revert HEAD
   git push origin main
   ```

2. **Restore from backup:**
   - Use GitHub commit history
   - Download previous version from releases

3. **Quick fixes:**
   - Update mirror links in `index.html`
   - Fix critical bugs and redeploy
   - Use GitHub Pages rollback feature

## Support Contacts

- **Primary:** contact@gta-san-andreas.in
- **GitHub Issues:** [Your repo URL]/issues
- **Documentation:** README.md

---

**Deployment Date:** _____________

**Deployed By:** _____________

**Version:** 2.0

**Notes:** 
_____________________________________________
_____________________________________________
_____________________________________________

---

*Keep this checklist updated with each deployment.*
