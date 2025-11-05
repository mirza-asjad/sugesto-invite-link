# Sugesto Invite Landing Page

This is the landing page for Sugesto app invite links, hosted on GitHub Pages.

## Setup GitHub Pages

1. **Push this repository to GitHub**:
   ```bash
   git add .
   git commit -m "Add invite landing page"
   git push origin main
   ```

2. **Enable GitHub Pages**:
   - Go to your repository on GitHub
   - Click on **Settings**
   - Scroll down to **Pages** section (in the left sidebar under "Code and automation")
   - Under **Source**, select **Deploy from a branch**
   - Select branch: `main` (or `asjad-dev` if that's your main branch)
   - Select folder: `/docs`
   - Click **Save**

3. **Wait for deployment** (usually takes 1-2 minutes)
   - GitHub will provide you with a URL like: `https://mirza-asjad.github.io/sugesto-invite-link/`
   - Your invite links will be: `https://mirza-asjad.github.io/sugesto-invite-link/?ref=INVITECODE`

4. **Update the invite service** (Already Done ✅):
   - The `lib/service/invite_service.dart` has been updated with:
     ```dart
     const baseUrl = 'https://mirza-asjad.github.io/sugesto-invite-link';
     ```

5. **Test your invite link**:
   - Visit: `https://mirza-asjad.github.io/sugesto-invite-link/?ref=TEST1234`
   - The page should display the invite code and app download options

## Custom Domain (Optional)

If you want to use a custom domain like `invite.sugesto.com`:

1. Add a `CNAME` file in the `docs` folder with your domain
2. Configure DNS settings with your domain provider
3. Update the domain in GitHub Pages settings

## Customization

- **Replace placeholder images**: Add your app banner image to `docs/assets/banner.png`
- **Update app package name**: Change `com.sugesto.app` in the HTML file
- **Add iOS App Store ID**: When your iOS app is published, add the App Store ID
- **Customize colors**: The current theme uses `#FFB000` (orange) to match your app

## Files

- `docs/index.html` - The invite landing page
- `docs/README.md` - This file

## How It Works

1. User shares invite link: `https://duseca.github.io/sugesto_app/?ref=ABC12345`
2. Friend clicks the link and opens the landing page
3. Landing page validates the invite code format
4. Landing page shows app info and download button
5. When friend clicks download, it attempts to open the app via deep link
6. If app is not installed, redirects to Play Store/App Store
7. Friend installs the app and registers with the invite code
8. App completes the invite process and rewards the inviter

## Deep Linking

To support deep linking, you need to configure your Flutter app:

### Android (already configured in your project)
- Update `android/app/src/main/AndroidManifest.xml`

### iOS
- Update `ios/Runner/Info.plist`

See the main README for detailed deep linking setup.
