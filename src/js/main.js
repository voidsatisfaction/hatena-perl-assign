import ArticlesController from './Controller/articles';
import MouseStalker from './Util/mouseStalker';

(function() {
  const $mouseStalker = new MouseStalker({
    width: '50px',
    height: '50px',
    imageUrl: 'https://cdn.worldvectorlogo.com/logos/gopher.svg',
  });
  const $mouseStalker2 = new MouseStalker({
    width: '50px',
    height: '50px',
    imageUrl: 'images/mad.png',
    diffX: 50,
    diffY: 70,
    id: 'hiyoko',
  });

  const $articlesContainer = document.querySelector('.articles-container') || undefined;
  const articlesController = new ArticlesController($articlesContainer);
})();
