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
}());
