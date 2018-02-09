import ArticlesController from './Controller/articles';

(function() {
  const $articlesContainer = document.querySelector('.articles-container');
  const articlesController = new ArticlesController($articlesContainer);
})();
