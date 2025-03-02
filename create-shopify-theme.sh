#!/bin/bash
# create-shopify-theme.sh - Automated Shopify Theme Creation Script
# Created with assistance from Claude AI

# Text colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Shopify CLI is installed
echo -e "${BLUE}Checking Shopify CLI installation...${NC}"
if ! command -v shopify &> /dev/null; then
  echo -e "${RED}Shopify CLI not found. Installing...${NC}"
  npm install -g @shopify/cli @shopify/theme
  if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to install Shopify CLI. Please install it manually.${NC}"
    exit 1
  fi
else
  echo -e "${GREEN}Shopify CLI is already installed.${NC}"
fi

# Get theme details
echo -e "${BLUE}Enter your theme details:${NC}"
read -p "Theme Name (e.g., My Awesome Store): " THEME_NAME
read -p "Theme Directory (default: ./shopify-theme): " THEME_DIR
THEME_DIR=${THEME_DIR:-"./shopify-theme"}
read -p "Primary Color (default: #3a3a3a): " PRIMARY_COLOR
PRIMARY_COLOR=${PRIMARY_COLOR:-"#3a3a3a"}
read -p "Secondary Color (default: #606060): " SECONDARY_COLOR
SECONDARY_COLOR=${SECONDARY_COLOR:-"#606060"}
read -p "Accent Color (default: #197bbd): " ACCENT_COLOR
ACCENT_COLOR=${ACCENT_COLOR:-"#197bbd"}

# Create directory structure
echo -e "${BLUE}Creating directory structure...${NC}"
mkdir -p "$THEME_DIR"/{assets,config,layout,sections,snippets,templates,locales}

# Create theme configuration file
echo -e "${BLUE}Creating theme configuration...${NC}"
cat > "$THEME_DIR/config/settings_schema.json" << EOL
[
  {
    "name": "theme_info",
    "theme_name": "${THEME_NAME}",
    "theme_version": "1.0.0",
    "theme_author": "AI-assisted Development",
    "theme_documentation_url": "https://github.com/your-username/shopify-theme",
    "theme_support_url": "https://github.com/your-username/shopify-theme/issues"
  },
  {
    "name": "Colors",
    "settings": [
      {
        "type": "header",
        "content": "Primary colors"
      },
      {
        "type": "color",
        "id": "color_primary",
        "label": "Primary color",
        "default": "${PRIMARY_COLOR}"
      },
      {
        "type": "color",
        "id": "color_secondary",
        "label": "Secondary color",
        "default": "${SECONDARY_COLOR}"
      },
      {
        "type": "color",
        "id": "color_accent",
        "label": "Accent color",
        "default": "${ACCENT_COLOR}"
      }
    ]
  },
  {
    "name": "Typography",
    "settings": [
      {
        "type": "header",
        "content": "Headings"
      },
      {
        "type": "font_picker",
        "id": "font_heading",
        "label": "Font",
        "default": "work_sans_n6"
      },
      {
        "type": "header",
        "content": "Body text"
      },
      {
        "type": "font_picker",
        "id": "font_body",
        "label": "Font",
        "default": "work_sans_n4"
      }
    ]
  },
  {
    "name": "Social media",
    "settings": [
      {
        "type": "header",
        "content": "Social accounts"
      },
      {
        "type": "text",
        "id": "social_twitter_link",
        "label": "Twitter",
        "info": "https://twitter.com/shopify"
      },
      {
        "type": "text",
        "id": "social_facebook_link",
        "label": "Facebook",
        "info": "https://facebook.com/shopify"
      },
      {
        "type": "text",
        "id": "social_instagram_link",
        "label": "Instagram",
        "info": "https://instagram.com/shopify"
      }
    ]
  }
]
EOL

# Create layout theme.liquid file
echo -e "${BLUE}Creating theme layout...${NC}"
cat > "$THEME_DIR/layout/theme.liquid" << 'EOL'
<!DOCTYPE html>
<html lang="{{ shop.locale }}">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <meta name="theme-color" content="{{ settings.color_primary }}">
  <link rel="canonical" href="{{ canonical_url }}">
  <title>
    {{ page_title }}{% if current_tags %} &ndash; tagged "{{ current_tags | join: ', ' }}"{% endif %}{% if current_page != 1 %} &ndash; Page {{ current_page }}{% endif %}{% unless page_title contains shop.name %} &ndash; {{ shop.name }}{% endunless %}
  </title>
  {% if page_description %}
    <meta name="description" content="{{ page_description | escape }}">
  {% endif %}

  <!-- Tailwind CSS CDN -->
  <script src="https://cdn.tailwindcss.com"></script>
  
  <!-- Custom CSS -->
  {{ 'theme.css' | asset_url | stylesheet_tag }}
  
  <!-- Header hook for plugins -->
  {{ content_for_header }}
  
  <!-- JSON-LD for SEO -->
  <script type="application/ld+json">
  {
    "@context": "http://schema.org",
    "@type": "WebSite",
    "name": "{{ shop.name }}",
    "potentialAction": {
      "@type": "SearchAction",
      "target": "{{ shop.url }}/search?q={search_term_string}",
      "query-input": "required name=search_term_string"
    },
    "url": "{{ shop.url }}{{ page.url }}"
  }
  </script>
</head>
<body class="template-{{ template | replace: '.', '-' | handle }}">
  <a class="skip-to-content-link sr-only focus:not-sr-only" href="#MainContent">
    {{ "accessibility.skip_to_content" | t }}
  </a>

  {% section 'header' %}

  <main role="main" id="MainContent" class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    {{ content_for_layout }}
  </main>

  {% section 'footer' %}

  <!-- Custom JavaScript -->
  {{ 'theme.js' | asset_url | script_tag }}
</body>
</html>
EOL

# Create header section
echo -e "${BLUE}Creating header section...${NC}"
cat > "$THEME_DIR/sections/header.liquid" << 'EOL'
<header class="bg-white shadow-md">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex justify-between h-16">
      <!-- Logo -->
      <div class="flex-shrink-0 flex items-center">
        {% if section.settings.logo != blank %}
          <a href="/" class="block h-8 w-auto">
            {{ section.settings.logo | img_url: '120x' | img_tag: shop.name, 'h-8 w-auto' }}
          </a>
        {% else %}
          <a href="/" class="text-xl font-bold text-gray-900">{{ shop.name }}</a>
        {% endif %}
      </div>

      <!-- Navigation -->
      <nav class="hidden md:ml-6 md:flex md:space-x-8" aria-label="Main navigation">
        {% for link in section.settings.menu.links %}
          <a href="{{ link.url }}" class="inline-flex items-center px-1 pt-1 text-sm font-medium text-gray-900 border-b-2 border-transparent hover:border-gray-300 hover:text-gray-700">
            {{ link.title }}
          </a>
        {% endfor %}
      </nav>

      <!-- Mobile menu button -->
      <div class="flex items-center md:hidden">
        <button id="mobile-menu-button" class="inline-flex items-center justify-center p-2 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-indigo-500" aria-expanded="false">
          <span class="sr-only">Open main menu</span>
          <svg class="block h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
          </svg>
        </button>
      </div>

      <!-- Cart and search icons -->
      <div class="hidden md:flex md:items-center">
        <a href="/search" class="p-2 text-gray-400 hover:text-gray-500">
          <span class="sr-only">Search</span>
          <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
          </svg>
        </a>
        <a href="/cart" class="ml-4 p-2 text-gray-400 hover:text-gray-500 relative">
          <span class="sr-only">Cart</span>
          <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
          </svg>
          <span class="absolute top-0 right-0 inline-flex items-center justify-center px-2 py-1 text-xs font-bold leading-none text-white transform translate-x-1/2 -translate-y-1/2 bg-red-600 rounded-full">
            {{ cart.item_count }}
          </span>
        </a>
      </div>
    </div>
  </div>

  <!-- Mobile menu -->
  <div id="mobile-menu" class="md:hidden hidden">
    <div class="pt-2 pb-3 space-y-1">
      {% for link in section.settings.menu.links %}
        <a href="{{ link.url }}" class="block px-4 py-2 text-base font-medium text-gray-700 hover:text-gray-900 hover:bg-gray-50">
          {{ link.title }}
        </a>
      {% endfor %}
    </div>
  </div>
</header>

{% schema %}
{
  "name": "Header",
  "settings": [
    {
      "type": "image_picker",
      "id": "logo",
      "label": "Logo"
    },
    {
      "type": "link_list",
      "id": "menu",
      "label": "Menu",
      "default": "main-menu"
    }
  ],
  "presets": [
    {
      "name": "Header",
      "category": "Header"
    }
  ]
}
{% endschema %}
EOL

# Create featured collection section
echo -e "${BLUE}Creating featured collection section...${NC}"
cat > "$THEME_DIR/sections/featured-collection.liquid" << 'EOL'
<div class="bg-white">
  <div class="max-w-7xl mx-auto py-16 px-4 sm:py-24 sm:px-6 lg:px-8">
    <div class="sm:flex sm:items-baseline sm:justify-between">
      <h2 class="text-2xl font-extrabold tracking-tight text-gray-900">{{ section.settings.title }}</h2>
      <a href="{{ section.settings.collection.url }}" class="hidden text-sm font-semibold text-indigo-600 hover:text-indigo-500 sm:block">
        {{ section.settings.view_all_text }}
        <span aria-hidden="true">&rarr;</span>
      </a>
    </div>

    <div class="mt-6 grid grid-cols-1 gap-y-10 gap-x-6 sm:grid-cols-2 lg:grid-cols-4 xl:gap-x-8">
      {% for product in section.settings.collection.products limit: section.settings.products_to_show %}
        <div class="group relative">
          <div class="w-full min-h-80 bg-gray-200 aspect-w-1 aspect-h-1 rounded-md overflow-hidden group-hover:opacity-75 lg:h-80 lg:aspect-none">
            <img src="{{ product.featured_image | img_url: '300x300', crop: 'center' }}" alt="{{ product.featured_image.alt }}" class="w-full h-full object-center object-cover lg:w-full lg:h-full">
          </div>
          <div class="mt-4 flex justify-between">
            <div>
              <h3 class="text-sm text-gray-700">
                <a href="{{ product.url }}">
                  <span aria-hidden="true" class="absolute inset-0"></span>
                  {{ product.title }}
                </a>
              </h3>
              <p class="mt-1 text-sm text-gray-500">{{ product.type }}</p>
            </div>
            <p class="text-sm font-medium text-gray-900">{{ product.price | money }}</p>
          </div>
        </div>
      {% else %}
        {% for i in (1..4) %}
          <div class="group relative">
            <div class="w-full min-h-80 bg-gray-200 aspect-w-1 aspect-h-1 rounded-md overflow-hidden group-hover:opacity-75 lg:h-80 lg:aspect-none">
              {{ 'product-' | append: i | placeholder_svg_tag: 'w-full h-full object-center object-cover lg:w-full lg:h-full' }}
            </div>
            <div class="mt-4 flex justify-between">
              <div>
                <h3 class="text-sm text-gray-700">
                  <a href="#">
                    <span aria-hidden="true" class="absolute inset-0"></span>
                    Sample Product {{ i }}
                  </a>
                </h3>
                <p class="mt-1 text-sm text-gray-500">Category</p>
              </div>
              <p class="text-sm font-medium text-gray-900">$35.00</p>
            </div>
          </div>
        {% endfor %}
      {% endfor %}
    </div>

    <div class="mt-6 sm:hidden">
      <a href="{{ section.settings.collection.url }}" class="text-sm font-semibold text-indigo-600 hover:text-indigo-500">
        {{ section.settings.view_all_text }}
        <span aria-hidden="true">&rarr;</span>
      </a>
    </div>
  </div>
</div>

{% schema %}
{
  "name": "Featured Collection",
  "settings": [
    {
      "type": "text",
      "id": "title",
      "label": "Heading",
      "default": "Featured Collection"
    },
    {
      "type": "collection",
      "id": "collection",
      "label": "Collection"
    },
    {
      "type": "range",
      "id": "products_to_show",
      "min": 4,
      "max": 12,
      "step": 4,
      "default": 4,
      "label": "Products to show"
    },
    {
      "type": "text",
      "id": "view_all_text",
      "label": "View all text",
      "default": "View all"
    }
  ],
  "presets": [
    {
      "name": "Featured Collection",
      "category": "Collection"
    }
  ]
}
{% endschema %}
EOL

# Create hero banner section
echo -e "${BLUE}Creating hero banner section...${NC}"
cat > "$THEME_DIR/sections/hero-banner.liquid" << 'EOL'
<div class="relative bg-gray-900">
  {% if section.settings.image != blank %}
    <div class="absolute inset-0">
      <img class="w-full h-full object-cover" src="{{ section.settings.image | img_url: '2000x' }}" alt="{{ section.settings.title }}">
      <div class="absolute inset-0 bg-gray-900 opacity-50"></div>
    </div>
  {% else %}
    <div class="absolute inset-0 bg-gradient-to-r from-purple-800 to-indigo-700"></div>
  {% endif %}

  <div class="relative max-w-7xl mx-auto py-24 px-4 sm:py-32 sm:px-6 lg:px-8">
    <h1 class="text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl">
      {{ section.settings.title }}
    </h1>
    <p class="mt-6 text-xl text-white max-w-3xl">
      {{ section.settings.subtitle }}
    </p>
    {% if section.settings.button_label != blank and section.settings.button_link != blank %}
      <div class="mt-10">
        <a href="{{ section.settings.button_link }}" class="inline-flex items-center px-6 py-3 border border-transparent text-base font-medium rounded-md text-indigo-700 bg-white hover:bg-gray-50">
          {{ section.settings.button_label }}
        </a>
      </div>
    {% endif %}
  </div>
</div>

{% schema %}
{
  "name": "Hero Banner",
  "settings": [
    {
      "type": "image_picker",
      "id": "image",
      "label": "Background image"
    },
    {
      "type": "text",
      "id": "title",
      "label": "Heading",
      "default": "Welcome to our store"
    },
    {
      "type": "textarea",
      "id": "subtitle",
      "label": "Subheading",
      "default": "Shop the latest trends and discover unique products that match your style."
    },
    {
      "type": "text",
      "id": "button_label",
      "label": "Button label",
      "default": "Shop Now"
    },
    {
      "type": "url",
      "id": "button_link",
      "label": "Button link"
    }
  ],
  "presets": [
    {
      "name": "Hero Banner",
      "category": "Hero"
    }
  ]
}
{% endschema %}
EOL

# Create CSS file
echo -e "${BLUE}Creating CSS file...${NC}"
cat > "$THEME_DIR/assets/theme.css" << 'EOL'
/* Base Shopify theme CSS */
/* Override default Tailwind styles as needed */

.aspect-w-1, .aspect-w-2, .aspect-w-3, .aspect-w-4, .aspect-w-5, .aspect-w-6, .aspect-w-7, .aspect-w-8, .aspect-w-9, .aspect-w-10, .aspect-w-11, .aspect-w-12, .aspect-w-13, .aspect-w-14, .aspect-w-15, .aspect-w-16 {
  position: relative;
  padding-bottom: calc(var(--tw-aspect-h) / var(--tw-aspect-w) * 100%);
}

.aspect-w-1 > *, .aspect-w-2 > *, .aspect-w-3 > *, .aspect-w-4 > *, .aspect-w-5 > *, .aspect-w-6 > *, .aspect-w-7 > *, .aspect-w-8 > *, .aspect-w-9 > *, .aspect-w-10 > *, .aspect-w-11 > *, .aspect-w-12 > *, .aspect-w-13 > *, .aspect-w-14 > *, .aspect-w-15 > *, .aspect-w-16 > * {
  position: absolute;
  height: 100%;
  width: 100%;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
}

.aspect-w-1 {
  --tw-aspect-w: 1;
}

.aspect-w-3 {
  --tw-aspect-w: 3;
}

.aspect-h-1 {
  --tw-aspect-h: 1;
}

.aspect-h-2 {
  --tw-aspect-h: 2;
}

/* Custom animation */
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.animate-fadeIn {
  animation: fadeIn 0.5s ease-in-out;
}

/* Custom styles for product cards */
.product-card {
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.product-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
}

/* Accessibility improvements */
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border-width: 0;
}

.focus\:not-sr-only:focus {
  position: static;
  width: auto;
  height: auto;
  padding: 0;
  margin: 0;
  overflow: visible;
  clip: auto;
  white-space: normal;
}

/* Skip to content link */
.skip-to-content-link {
  position: absolute;
  top: -50px;
  left: 0;
  background: #fff;
  color: #000;
  padding: 8px;
  z-index: 100;
  transition: top 0.2s;
}

.skip-to-content-link:focus {
  top: 0;
}
EOL

# Create JavaScript file
echo -e "${BLUE}Creating JavaScript file...${NC}"
cat > "$THEME_DIR/assets/theme.js" << 'EOL'
// AI-Powered Shopify Theme JS
document.addEventListener('DOMContentLoaded', function() {
  // Mobile menu toggle
  const mobileMenuButton = document.getElementById('mobile-menu-button');
  const mobileMenu = document.getElementById('mobile-menu');
  if (mobileMenuButton && mobileMenu) {
    mobileMenuButton.addEventListener('click', function() {
      const expanded = mobileMenuButton.getAttribute('aria-expanded') === 'true';
      mobileMenuButton.setAttribute('aria-expanded', !expanded);
      if (expanded) {
        mobileMenu.classList.add('hidden');
      } else {
        mobileMenu.classList.remove('hidden');
      }
    });
  }

  // Lazy load images when they come into view
  if ('IntersectionObserver' in window) {
    const images = document.querySelectorAll('img[loading="lazy"]');
    const imageObserver = new IntersectionObserver((entries, observer) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const image = entry.target;
          const dataSrc = image.getAttribute('data-src');
          if (dataSrc) {
            image.src = dataSrc;
            image.removeAttribute('data-src');
          }
          imageObserver.unobserve(image);
        }
      });
    });
    images.forEach(image => {
      imageObserver.observe(image);
    });
  }

  // Add to cart AJAX functionality for "Add to Cart" forms
  const addToCartForms = document.querySelectorAll('.js-add-to-cart-form');
  addToCartForms.forEach(form => {
    form.addEventListener('submit', function(e) {
      e.preventDefault();
      const formData = new FormData(form);
      const submitButton = form.querySelector('[type="submit"]');
      const originalButtonText = submitButton.textContent;
      
      submitButton.disabled = true;
      submitButton.textContent = 'Adding...';
      
      fetch('/cart/add.js', {
        method: 'POST',
        body: formData
      })
      .then(response => response.json())
      .then(data => {
        // Update cart count
        updateCartCount();
        
        // Show success message
        const successMessage = document.createElement('div');
        successMessage.classList.add('text-green-500', 'mt-2', 'animate-fadeIn');
        successMessage.textContent = 'Item added to cart!';
        form.appendChild(successMessage);
        
        setTimeout(() => {
          successMessage.remove();
        }, 3000);
      })
      .catch(error => {
        console.error('Error adding to cart:', error);
        
        // Show error message
        const errorMessage = document.createElement('div');
        errorMessage.classList.add('text-red-500', 'mt-2');
        errorMessage.textContent = 'Could not add to cart. Please try again.';
        form.appendChild(errorMessage);
        
        setTimeout(() => {
          errorMessage.remove();
        }, 3000);
      })
      .finally(() => {
        submitButton.disabled = false;
        submitButton.textContent = originalButtonText;
      });
    });
  });

  // Update cart count in header
  function updateCartCount() {
    fetch('/cart.js')
      .then(response => response.json())
      .then(cart => {
        const cartCountElements = document.querySelectorAll('.js-cart-count');
        cartCountElements.forEach(element => {
          element.textContent = cart.item_count;
          element.classList.toggle('hidden', cart.item_count === 0);
        });
      })
      .catch(error => console.error('Error fetching cart:', error));
  }

  // Initialize cart count on page load
  updateCartCount();
});
EOL

# Create index template
echo -e "${BLUE}Creating index template...${NC}"
cat > "$THEME_DIR/templates/index.liquid" << 'EOL'
{% section 'hero-banner' %}
{% section 'featured-collection' %}
EOL

# Make the script executable
chmod +x "$THEME_DIR/create-shopify-theme.sh"

# Final instructions
echo -e "${GREEN}Theme structure created successfully in ${THEME_DIR}${NC}"
echo -e "${BLUE}Next steps:${NC}"
echo -e "1. Upload the theme to your Shopify store with: ${YELLOW}shopify theme push --store=your-store.myshopify.com${NC}"
echo -e "2. Or develop locally with: ${YELLOW}shopify theme dev --store=your-store.myshopify.com${NC}"
echo -e "${GREEN}Happy Shopify theming!${NC}"
