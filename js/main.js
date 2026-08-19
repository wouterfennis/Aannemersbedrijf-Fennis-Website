(function () {
  "use strict";

  // Mobile navigation toggle
  var toggle = document.querySelector(".nav-toggle");
  var nav = document.getElementById("main-nav");

  if (toggle && nav) {
    toggle.addEventListener("click", function () {
      var isOpen = nav.classList.toggle("open");
      toggle.setAttribute("aria-expanded", isOpen ? "true" : "false");
      toggle.setAttribute("aria-label", isOpen ? "Menu sluiten" : "Menu openen");
    });

    nav.querySelectorAll("a").forEach(function (link) {
      link.addEventListener("click", function () {
        nav.classList.remove("open");
        toggle.setAttribute("aria-expanded", "false");
        toggle.setAttribute("aria-label", "Menu openen");
      });
    });
  }

  // Footer year
  var yearEl = document.getElementById("current-year");
  if (yearEl) {
    yearEl.textContent = new Date().getFullYear();
  }

  // Mark all decorative SVGs as hidden from AT (WCAG 1.1.1)
  document.querySelectorAll("svg:not([aria-label]):not([role])").forEach(function (svg) {
    svg.setAttribute("aria-hidden", "true");
    svg.setAttribute("focusable", "false");
  });

  // Warn AT users when a link opens in a new tab
  document.querySelectorAll("a[target='_blank']").forEach(function (link) {
    var warn = document.createElement("span");
    warn.className = "visually-hidden";
    warn.textContent = " (opent in nieuw tabblad)";
    link.appendChild(warn);
  });

  // Photo grid lightbox
  var lightbox = document.getElementById("lightbox");
  if (lightbox) {
    var lightboxImage = lightbox.querySelector(".lightbox-image");
    var lightboxCaption = lightbox.querySelector(".lightbox-caption");
    var lightboxClose = lightbox.querySelector(".lightbox-close");
    var lightboxPrev = lightbox.querySelector(".lightbox-prev");
    var lightboxNext = lightbox.querySelector(".lightbox-next");

    var galleries = [];
    document.querySelectorAll(".photo-grid").forEach(function (grid) {
      var triggers = Array.prototype.slice.call(grid.querySelectorAll(".photo-grid-trigger"));
      if (triggers.length) {
        galleries.push(triggers);
      }
    });

    var currentTriggers = null;
    var currentIndex = 0;
    var lastFocusedTrigger = null;

    function openLightbox(triggers, index) {
      var trigger = triggers[index];
      var img = trigger.querySelector("img");
      var figcaption = trigger.parentElement.querySelector("figcaption");

      currentTriggers = triggers;
      currentIndex = index;
      lastFocusedTrigger = trigger;

      lightboxImage.src = img.src;
      lightboxImage.alt = img.alt;
      lightboxCaption.textContent = figcaption ? figcaption.textContent : "";

      lightbox.removeAttribute("hidden");
      document.body.classList.add("lightbox-open");
      lightboxClose.focus();
    }

    function closeLightbox() {
      lightbox.setAttribute("hidden", "");
      document.body.classList.remove("lightbox-open");
      if (lastFocusedTrigger) {
        lastFocusedTrigger.focus();
      }
    }

    function showPrev() {
      var length = currentTriggers.length;
      openLightbox(currentTriggers, (currentIndex - 1 + length) % length);
    }

    function showNext() {
      var length = currentTriggers.length;
      openLightbox(currentTriggers, (currentIndex + 1) % length);
    }

    galleries.forEach(function (triggers) {
      triggers.forEach(function (trigger, index) {
        trigger.addEventListener("click", function () {
          openLightbox(triggers, index);
        });
      });
    });

    lightboxClose.addEventListener("click", closeLightbox);
    lightboxPrev.addEventListener("click", showPrev);
    lightboxNext.addEventListener("click", showNext);

    lightbox.addEventListener("click", function (event) {
      if (event.target === lightbox) {
        closeLightbox();
      }
    });

    document.addEventListener("keydown", function (event) {
      if (lightbox.hasAttribute("hidden")) {
        return;
      }
      if (event.key === "Escape") {
        closeLightbox();
      } else if (event.key === "ArrowLeft") {
        showPrev();
      } else if (event.key === "ArrowRight") {
        showNext();
      }
    });
  }
}());
