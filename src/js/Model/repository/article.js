import Article from '../entity/article';

import { fetchGet } from '../../Util/fetch';

export default class ArticleRepository {
  fetchArticlesWithPagination(params) {
    if (!params) {
      params = {};
    }
    const page = params.page || 0;
    const perPage = params.perPage || 10;
    const url = `http://localhost:13000/api/articles?page=${page}&per_page=${perPage}`;
    return fetchGet(url)
      .then((res) => {
        res.next_page = Number(res.next_page);
        res.per_page = Number(res.per_page);
        res.articles = res.articles.map((raw) => new Article(raw));
        return res;
      })
      .catch((error) => {
        throw error;
      });
  }
}
