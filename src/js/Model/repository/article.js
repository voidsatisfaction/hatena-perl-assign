import Article from '../entity/article';

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

function fetchGet(url) {
  return new Promise((resolve, reject) => {
    const req = new XMLHttpRequest();

    req.onreadystatechange = function() {
      const res = req.response;
      if (req.readyState === 4 && req.status === 200) {
        const resJSON = JSON.parse(res);
        resolve(resJSON);
      }
      if (req.status === 404 || req.status === 403 || req.status === 500) {
        reject(req.statusText);
      }
    };

    req.open('GET', url);
    req.send();
  });
}
