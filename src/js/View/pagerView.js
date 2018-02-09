export default class PagerView {
  constructor($element) {
    this.$container = $element;
    this.$pagination = this.$container.querySelector('.pagination');
    this.$prevButton = this.$pagination.querySelector('.prev-button');
    this.$nextButton = this.$pagination.querySelector('.next-button');
    this.$currentPage = this.$pagination.querySelector('.current-page');
    this.$pagination.addEventListener('click', (e) => {
      const perPage = Number(this.$pagination.getAttribute('data-per-page'));
      switch (e.target.className) {
        case 'prev-button':
          const $prevButton = this.$prevButton;
          const prevPage = Number($prevButton.getAttribute('data-prev-page'));
          const changeArticlePagePrevEvent = new CustomEvent('changeArticlePage', {
            detail: {
              perPage: perPage,
              page: prevPage,
            },
          });
          document.dispatchEvent(changeArticlePagePrevEvent);
          break;
        case 'next-button':
          const $nextButton = this.$nextButton;
          const nextPage = Number($nextButton.getAttribute('data-next-page'));
          const changeArticlePageNextEvent = new CustomEvent('changeArticlePage', {
            detail: {
              perPage: perPage,
              page: nextPage,
            },
          });
          document.dispatchEvent(changeArticlePageNextEvent);
          break;
        default:
          console.error(e);
      }
    })
  }

  _paginationElement(perPage, nextPage) {
    const $pagination = this.$pagination;
    const $nextButton = this.$nextButton;
    const $prevButton = this.$prevButton;

    $pagination.setAttribute('data-per-page', perPage);

    if (nextPage === 1) {
      $prevButton.setAttribute('hidden', true);
    } else {
      $prevButton.removeAttribute('hidden');
    }
    $nextButton.setAttribute('data-next-page', nextPage);
    $prevButton.setAttribute('data-prev-page', nextPage-2);

    const $currentPage = this.$currentPage;
    const $currentPageText = document.createTextNode(`page ${nextPage}`);
    $currentPage.innerHTML = '';
    $currentPage.appendChild($currentPageText);
  }

  render(perPage, nextPage) {
    this._paginationElement(perPage, nextPage);
  }
}
