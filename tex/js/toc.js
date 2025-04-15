document.addEventListener('DOMContentLoaded', function() {
  const chapterTocs = document.querySelectorAll('nav.TOC span.chapterToc');
  chapterTocs.forEach(function(chapterToc) {
    chapterToc.addEventListener('click', function(event) {
      const nextElement = chapterToc.nextElementSibling;
      if (nextElement && nextElement.classList.contains('sectionToc') && nextElement.tagName === 'SPAN') {
        // if the next element is a sectionToc, prevent the default action
        // otherwise, the chapter doesn't contain any sections and should be opened
        event.preventDefault(); 
      }
      const chapterTocs = chapterToc.parentNode.querySelectorAll('span.chapterToc');
      // remove the clicked class from all other chapterTocs
      chapterTocs.forEach(function(otherChapterToc) {
        if (otherChapterToc !== chapterToc) {
          otherChapterToc.classList.remove('clicked');
        }
      });
      chapterToc.classList.toggle('clicked');
    });
  });
});

