document.addEventListener('DOMContentLoaded', function() {
  const chapterTocs = document.querySelectorAll('nav.TOC span.chapterToc');
  
  function handleChapterTocClick(event) {
    const nextElement = this.nextElementSibling;
    if (nextElement && nextElement.classList.contains('sectionToc')) {
      event.preventDefault(); 
    }
    
    const chapterTocs = this.parentNode.querySelectorAll('span.chapterToc');
    chapterTocs.forEach(function(otherChapterToc) {
      if (otherChapterToc !== this) {
        otherChapterToc.classList.remove('clicked');
      }
    }.bind(this));
    
    this.classList.toggle('clicked');
  }
  
  chapterTocs.forEach(function(chapterToc) {
    chapterToc.addEventListener('click', handleChapterTocClick);
  });
  
  // Check current page on load
  const currentPage = window.location.pathname.split('/').pop();
  const navLinks = document.querySelectorAll('nav.TOC a[href]');
  let foundLink = false;
  
  navLinks.forEach(function(link) {
    let linkPage = link.getAttribute('href').split('/').pop();
    linkPage = linkPage.split('#')[0]; // Remove hash and everything after it
    
    // If linkPage is empty (just #id) or matches current page
    if (linkPage === '' || linkPage === currentPage) {
      foundLink = true;
      let prevElement = link.closest('.sectionToc')?.previousElementSibling;
      while (prevElement) {
        if (prevElement.classList.contains('chapterToc')) {
          prevElement.classList.add('clicked');
          break;
        }
        prevElement = prevElement.previousElementSibling;
      }
    }
  });
  
  if (!foundLink && chapterTocs.length > 0) {
    chapterTocs[0].classList.add('clicked');
  }
});