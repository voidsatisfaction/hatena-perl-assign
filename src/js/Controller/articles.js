import ArticleRepository from '../Model/repository/article';

import PagerView from '../View/pagerView';
import ArticlesView from '../View/articlesView';

export default class ArticlesController {
  constructor($element) {
    if (!$element) {
      return
    }
    this.$element = $element;
    this.articleView = new ArticlesView(this.$element);
    this.pagerView = new PagerView(this.$element)
    this.articles = [];

    document.addEventListener('changeArticlePage', this.changeArticlePage.bind(this));

    this.updateArticlesAndRender();
  }

  updateArticlesAndRender(page, perPage) {
    this._updateArticlesAndPagenationState(page, perPage)
      .then(() => {
        this.articleView.render(this.articles, this.perPage, this.nextPage);
        this.pagerView.render(this.perPage, this.nextPage);
      })
      .catch((err) => {
        console.error(err);
      })
  }

  changeArticlePage(e) {
    const page = e.detail.page;
    const perPage = e.detail.perPage;
    this.updateArticlesAndRender(page, perPage);
  }

  _updateArticlesAndPagenationState(page, perPage) {
    const params = {page, perPage};
    const articleRepos = new ArticleRepository();
    return articleRepos.fetchArticlesWithPagination(params)
      .then((res) => {
        this.articles = res.articles;
        this.nextPage = res.next_page;
        this.perPage = res.per_page;
      })
      .catch((err) => {
        return err;
      })
  }
}
