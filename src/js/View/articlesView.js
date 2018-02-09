export default class ArticlesView {
  constructor($element) {
    this.$container = $element;
    this.$articles = this.$container.querySelector('.articles');
  }

  _articleElement(article) {
    const $article = document.createElement('div');
    const $title = document.createElement('h3');
    const $body = document.createElement('p');

    const $titleText = document.createTextNode(article.title);
    const $bodyText = document.createTextNode(article.body);

    $title.appendChild($titleText);
    $body.appendChild($bodyText);

    $article.appendChild($title);
    $article.appendChild($body);

    return $article;
  }

  render(articles, perPage, nextPage) {
    this.$articles.innerHTML = '';
    articles.forEach((article) => {
      const $article = this._articleElement(article);
      this.$articles.appendChild($article);
    });
  }
}
