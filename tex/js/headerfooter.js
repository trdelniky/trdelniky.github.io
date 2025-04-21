document.addEventListener("DOMContentLoaded", () => {
  const header = document.querySelector("header");
  const menu = document.querySelector("nav.TOC");
  const footer = document.querySelector("footer");

  let lastScrollY = window.scrollY;

  function updateHeaderAndMenu() {
    const currentScrollY = window.scrollY;

    if (currentScrollY > lastScrollY) {
      // Scrolling down – hide the header and shift the menu up
      header.style.transform = "translateY(-100%)";
      const headerHeight = header.offsetHeight + "px";
      menu.style.transform = `translateY(-${headerHeight})`;
    } else {
      // Scrolling up – show the header and reset menu position
      header.style.transform = "translateY(0)";
      menu.style.transform = "translateY(0)";
    }

    lastScrollY = currentScrollY;
  }

  function updateFooter() {
    const scrollBottom = window.scrollY + window.innerHeight;
    const docHeight = document.documentElement.scrollHeight;

    if (scrollBottom >= docHeight || docHeight <= window.innerHeight) {
      footer.style.display = "flex";
    } else {
      footer.style.display = "none";
    }
  }

  window.addEventListener("scroll", () => {
    updateHeaderAndMenu();
    updateFooter();
  });

  window.addEventListener("resize", updateFooter);

  updateFooter(); // On initial load
});
