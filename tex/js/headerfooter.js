document.addEventListener("DOMContentLoaded", () => {
  const header = document.querySelector("header");
  const menu = document.querySelector("nav.TOC");
  const sectionTocs = document.querySelector(".sectionTOCS");
  const footer = document.querySelector("footer");

  let lastScrollY = window.scrollY;

  function isMenuVisible(el){
    // the menu is hidden by translateX transformation when the display is not wide enough
    // we need to check if the menu is visible before applying more transformations
    const style = window.getComputedStyle(el);
    const transform = style.transform;

    if (transform && transform !== 'none') {
      // Typicky něco jako: "matrix(1, 0, 0, 1, -200, 0)"
      const matrix = new DOMMatrixReadOnly(transform);
      const translateX = matrix.m41; // ← tady je to
      if (translateX < 0) {
        console.log('menu hidden');
        return false;
      }
    } else {
      console.log('No transform applied');
    }
    return true;
  }

  function updateHeaderAndMenu() {
    const currentScrollY = window.scrollY;

    if (currentScrollY > lastScrollY) {
      // Scrolling down – hide the header and shift the menu up
      header.style.transform = "translateY(-100%)";
      const headerHeight = header.offsetHeight + "px";
      if(isMenuVisible(menu)) menu.style.transform = `translateY(-${headerHeight})`;
      sectionTocs.style.transform = `translateY(-${headerHeight})`;
    } else {
      // Scrolling up – show the header and reset menu position
      header.style.transform = "translateY(0)";
      if(isMenuVisible(menu)) menu.style.transform = "translateY(0)";
      sectionTocs.style.transform = "translateY(0)";
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
