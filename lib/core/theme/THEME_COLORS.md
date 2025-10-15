# Theme Color Reference

This document provides a quick visual reference for all 5 theme variants in the Pictogram app.

## Theme Variants Overview

### 1. Default Purple (defaultTheme)
**Seed Color:** `#6750A4` (Deep Purple)

**Characteristics:**
- Professional and modern
- Creative and innovative
- Excellent for branding
- High contrast with good readability

**Best Use Cases:**
- Default theme for the application
- Creative and design applications
- Professional business tools
- General-purpose applications

**Color Palette:**
- Primary: Deep purple tones
- Secondary: Complementary purple-pink
- Tertiary: Balanced accent colors
- Error: Material red

---

### 2. Blue Gray (blueGray)
**Seed Color:** `#546E7A` (Blue Gray)

**Characteristics:**
- Calm and sophisticated
- Neutral and professional
- Easy on the eyes for long sessions
- Modern corporate feel

**Best Use Cases:**
- Professional and enterprise applications
- Data visualization tools
- Analytics dashboards
- Business productivity apps

**Color Palette:**
- Primary: Cool blue-gray tones
- Secondary: Muted blue accents
- Tertiary: Soft complementary colors
- Error: Material red

---

### 3. Gray (gray)
**Seed Color:** `#616161` (Gray)

**Characteristics:**
- Minimalist and elegant
- Timeless and classic
- Content-focused
- Extremely versatile

**Best Use Cases:**
- Content-heavy applications
- Reading and document apps
- Minimalist design preferences
- Text editors and note-taking apps

**Color Palette:**
- Primary: Neutral gray scale
- Secondary: Warm gray accents
- Tertiary: Subtle color highlights
- Error: Material red

---

### 4. Teal (teal)
**Seed Color:** `#00897B` (Teal)

**Characteristics:**
- Fresh and energetic
- Modern and vibrant
- Natural and calming
- Positive and uplifting

**Best Use Cases:**
- Health and wellness apps
- Environmental and nature themes
- Education platforms
- Communication tools

**Color Palette:**
- Primary: Vibrant teal tones
- Secondary: Cyan-green accents
- Tertiary: Complementary warm colors
- Error: Material red

---

### 5. Yellow (yellow)
**Seed Color:** `#F9A825` (Yellow)

**Characteristics:**
- Warm and optimistic
- Cheerful and energetic
- Attention-grabbing
- Creative and playful

**Best Use Cases:**
- Educational applications
- Creative and design tools
- Entertainment and media apps
- Youth-oriented applications

**Color Palette:**
- Primary: Warm yellow-gold tones
- Secondary: Orange-amber accents
- Tertiary: Balanced complementary colors
- Error: Material red

---

## Material Design 3 Color Roles

Each theme includes these semantic color roles:

### Surface Colors
- **surface**: Main background color for cards and sheets
- **surfaceVariant**: Alternate surface for differentiation
- **surfaceTint**: Subtle color tint applied to surfaces

### Content Colors
- **onSurface**: Primary text and icons on surfaces
- **onSurfaceVariant**: Secondary text and icons
- **outline**: Borders and dividers
- **outlineVariant**: Subtle borders

### Primary Colors
- **primary**: Main brand color for key actions
- **onPrimary**: Text/icons on primary color
- **primaryContainer**: Tinted containers with primary
- **onPrimaryContainer**: Content on primary containers

### Secondary Colors
- **secondary**: Supporting brand color
- **onSecondary**: Text/icons on secondary color
- **secondaryContainer**: Tinted containers with secondary
- **onSecondaryContainer**: Content on secondary containers

### Tertiary Colors
- **tertiary**: Accent color for variety
- **onTertiary**: Text/icons on tertiary color
- **tertiaryContainer**: Tinted containers with tertiary
- **onTertiaryContainer**: Content on tertiary containers

### Utility Colors
- **error**: Error states and warnings
- **onError**: Text/icons on error color
- **errorContainer**: Error backgrounds
- **onErrorContainer**: Content on error backgrounds

### Special Colors
- **inverseSurface**: Inverted surface (for tooltips, snackbars)
- **onInverseSurface**: Content on inverted surface
- **inversePrimary**: Inverted primary color
- **shadow**: Shadow color
- **scrim**: Screen overlay color

---

## Accessibility

All themes meet WCAG AA accessibility standards:

- **Contrast Ratios**: Minimum 4.5:1 for normal text, 3:1 for large text
- **Touch Targets**: Minimum 48x48dp for all interactive elements
- **Color Independence**: Information not conveyed by color alone
- **Focus Indicators**: Clear visual focus for keyboard navigation

---

## Dark Mode Variants

Each theme automatically generates a dark mode variant with:

- Inverted luminance values
- Reduced saturation for comfort
- Higher contrast for readability
- OLED-optimized pure black options
- Consistent color relationships

---

## Usage Examples

### Accessing Theme Colors

```dart
// Get color scheme
final colors = Theme.of(context).colorScheme;

// Use primary color
Container(color: colors.primary)

// Use surface color
Card(color: colors.surface)

// Use semantic text styles
Text(
  'Headline',
  style: Theme.of(context).textTheme.headlineLarge,
)
```

### Theme-Aware Widgets

```dart
// Buttons automatically use theme colors
ElevatedButton(
  onPressed: () {},
  child: const Text('Primary Action'),
)

OutlinedButton(
  onPressed: () {},
  child: const Text('Secondary Action'),
)

// Cards use surface colors
Card(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text('Card content'),
  ),
)
```

---

## Testing Your UI

When implementing UI, test with:

1. **All 5 color themes** - Ensure consistency
2. **Light and dark modes** - Verify readability
3. **Different screen sizes** - Responsive design
4. **Color blindness simulation** - Accessibility
5. **High contrast mode** - Visibility

---

## Customization

To customize a theme:

1. Modify the seed color in `app_themes.dart`
2. Adjust individual component themes as needed
3. Maintain Material Design 3 principles
4. Test accessibility standards
5. Verify in both light and dark modes

---

## Resources

- Material Design 3: https://m3.material.io/
- Color Tool: https://m3.material.io/theme-builder
- Accessibility: https://www.w3.org/WAI/WCAG21/quickref/
- Flutter Theming: https://docs.flutter.dev/cookbook/design/themes
