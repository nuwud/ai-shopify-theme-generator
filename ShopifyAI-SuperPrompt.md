# AI-Assisted Shopify Theme Development Super Prompt

Use this prompt with Claude 3.7 Sonnet or other advanced AI assistants to create a complete Shopify theme structure quickly and efficiently.

## Prompt Template

```
I need your help to create a complete Shopify theme structure for a [DESCRIBE STORE TYPE] store. I want modern, responsive design with Tailwind CSS integration. Please help me generate all the necessary files in a proper Shopify theme directory structure.

For this theme, I need:
- A clean, modern layout with responsive design
- A homepage featuring a hero banner, featured collection, and promotional sections
- Product and collection pages that showcase items effectively
- Mobile-friendly navigation with a hamburger menu on small screens
- Optimized for fast loading and good SEO
- Accessibility features throughout

The theme's primary colors should be [COLOR SCHEME DETAILS] with typography using [FONT PREFERENCES].

Please create the complete directory structure with all necessary files. For each file, explain what it does and how it contributes to the theme. Then provide the actual code for each file that I can copy directly into my project.

When creating the theme, focus on these key components:
1. Theme layout (theme.liquid)
2. Homepage sections (hero, collections, promotional areas)
3. Product display and variations
4. Navigation and header/footer
5. Cart functionality
6. Assets (CSS/JS)
7. Theme settings schema

If you can access the filesystem, please create this structure in [SPECIFY DIRECTORY PATH]. If not, provide the complete set of files I should create.
```

## Important Notes for the AI

- You need a full Shopify theme structure: `/assets`, `/config`, `/layout`, `/sections`, `/snippets`, `/templates`, and `/locales`
- Essential files include:
  - `theme.liquid` (main layout)
  - `settings_schema.json` (theme configuration)
  - Homepage template and sections
  - CSS and JavaScript assets
- Write clean, modern code with Tailwind CSS
- Include proper schema settings for each section to make them customizable
- Ensure full responsiveness and mobile compatibility
- Maintain accessibility best practices (semantic HTML, ARIA attributes, etc.)
- Create modular, reusable components where possible

## Avoiding Common Pitfalls

- Don't create flat directory structures - maintain proper Shopify theme hierarchy
- Ensure all schema sections are valid JSON with proper syntax
- Include all required Shopify Liquid objects and filters
- Don't overlook cart functionality and product variations
- Make sure navigation is fully responsive with proper mobile implementation
- Remember to include proper asset references (CSS/JS) in the theme.liquid file