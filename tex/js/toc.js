document.addEventListener('DOMContentLoaded', function() {
  const chapterTocs = document.querySelectorAll('nav.TOC span.chapterToc');
  chapterTocs.forEach(function(chapterToc) {
    chapterToc.addEventListener('click', function(event) {
      event.preventDefault(); // zabránit otevření stránky
      const chapterTocs = chapterToc.parentNode.querySelectorAll('span.chapterToc');
      chapterTocs.forEach(function(otherChapterToc) {
        otherChapterToc.classList.remove('clicked');
      });
      const sectionTocs = chapterToc.parentNode.querySelectorAll('span.sectionToc');
      sectionTocs.forEach(function(sectionToc) {
        if (chapterToc.classList.contains('clicked')) {
          sectionToc.classList.add('show');
        } else {
          sectionToc.classList.remove('show');
        }
      });
      chapterToc.classList.toggle('clicked');
    });
  });
});

