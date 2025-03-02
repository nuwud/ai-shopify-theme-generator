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