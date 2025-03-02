# AI-Generated Shopify Theme

A modern, responsive Shopify theme created with AI assistance. This theme includes all the essential components for a complete e-commerce store with clean design and best practices implemented throughout.

## Features

- **Modern Design**: Built with TailwindCSS for sleek, responsive UI
- **Performance Focused**: Optimized for fast loading and smooth user experience
- **SEO Ready**: Proper metadata structure and schema markup
- **Accessible**: WCAG compliance for better accessibility
- **Shopify 2.0 Compatible**: Utilizing Shopify's latest features and APIs
- **Customizable**: Easy-to-modify theme settings for merchants

## File Structure

```
├── assets/
│   ├── theme.css     # Main CSS file
│   ├── theme.js      # Main JavaScript file
├── config/
│   ├── settings_schema.json  # Theme settings configuration
├── layout/
│   ├── theme.liquid  # Main layout template
├── sections/
│   ├── cart-template.liquid          # Cart page section
│   ├── collection-header.liquid      # Collection page header
│   ├── collection-template.liquid    # Collection page content
│   ├── featured-collection.liquid    # Featured products section
│   ├── footer.liquid                 # Site footer
│   ├── header.liquid                 # Site header
│   ├── hero-banner.liquid            # Hero/banner section
│   ├── product-recommendations.liquid # Product recommendations
│   ├── product-template.liquid       # Product page template
├── snippets/
│   # Reusable code snippets
├── templates/
│   ├── cart.liquid        # Cart page
│   ├── collection.liquid  # Collection pages
│   ├── index.liquid       # Homepage
│   ├── product.liquid     # Product page
```

## Getting Started

### Prerequisites

- Node.js (for local development)
- Shopify CLI installed
- A Shopify store (developer or partner account)

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/nuwud/ai-shopify-theme-generator.git
   cd ai-shopify-theme-generator
   ```

2. Use the provided shell script to create a new theme:
   ```bash
   ./create-shopify-theme.sh
   ```

3. Upload to your Shopify store:
   ```bash
   cd shopify_theme
   shopify theme push --store=your-store.myshopify.com
   ```

4. Or develop locally with Theme Kit:
   ```bash
   shopify theme dev --store=your-store.myshopify.com
   ```

## Theme Configuration

### Theme Settings

The theme includes several customization options in the Shopify admin panel:

1. **Colors**
   - Primary color
   - Secondary color
   - Accent color
   - Background color
   - Text color

2. **Typography**
   - Heading font
   - Body font
   - Size scaling

3. **Social Media**
   - Social media account links

4. **Layout Options**
   - Header style
   - Footer configuration
   - Product grid layout

## Key Components

### Homepage

The homepage includes:
- Hero banner with customizable image, heading, subheading, and button
- Featured collection with product cards
- Additional sections can be added through the Shopify theme editor

### Product Pages

Product pages include:
- Image gallery with thumbnails
- Product details (title, price, description)
- Variant selectors
- Add to cart functionality
- Dynamic checkout buttons
- Product recommendations

### Collection Pages

Collection pages include:
- Collection header with optional image and description
- Product filtering and sorting
- Responsive product grid
- Pagination

### Cart

The cart page includes:
- Line item display with images, titles, and prices
- Quantity adjusters
- Remove item functionality
- Cart notes
- Checkout button

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Created with assistance from AI (Claude)
- Uses TailwindCSS for styling
- Built for Shopify e-commerce platform
