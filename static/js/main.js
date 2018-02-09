/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__(1);


/***/ }),
/* 1 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__Controller_articles__ = __webpack_require__(2);


(function () {
  const $articlesContainer = document.querySelector('.articles-container');
  const articlesController = new __WEBPACK_IMPORTED_MODULE_0__Controller_articles__["a" /* default */]($articlesContainer);
})();

/***/ }),
/* 2 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__Model_repository_article__ = __webpack_require__(3);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__View_pagerView__ = __webpack_require__(5);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__View_articlesView__ = __webpack_require__(6);





class ArticlesController {
  constructor($element) {
    this.$element = $element;
    this.articleView = new __WEBPACK_IMPORTED_MODULE_2__View_articlesView__["a" /* default */](this.$element);
    this.pagerView = new __WEBPACK_IMPORTED_MODULE_1__View_pagerView__["a" /* default */](this.$element);
    this.articles = [];

    document.addEventListener('changeArticlePage', this.changeArticlePage.bind(this));

    this.updateArticlesAndRender();
  }

  updateArticlesAndRender(page, perPage) {
    this._updateArticlesAndPagenationState(page, perPage).then(() => {
      this.articleView.render(this.articles, this.perPage, this.nextPage);
      this.pagerView.render(this.perPage, this.nextPage);
    }).catch(err => {
      console.error(err);
    });
  }

  changeArticlePage(e) {
    const page = e.detail.page;
    const perPage = e.detail.perPage;
    this.updateArticlesAndRender(page, perPage);
  }

  _updateArticlesAndPagenationState(page, perPage) {
    const params = { page, perPage };
    const articleRepos = new __WEBPACK_IMPORTED_MODULE_0__Model_repository_article__["a" /* default */]();
    return articleRepos.fetchArticlesWithPagination(params).then(res => {
      this.articles = res.articles;
      this.nextPage = res.next_page;
      this.perPage = res.per_page;
    }).catch(err => {
      return err;
    });
  }
}
/* harmony export (immutable) */ __webpack_exports__["a"] = ArticlesController;


/***/ }),
/* 3 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__entity_article__ = __webpack_require__(4);


class ArticleRepository {
  fetchArticlesWithPagination(params) {
    if (!params) {
      params = {};
    }
    const page = params.page || 0;
    const perPage = params.perPage || 10;
    const url = `http://localhost:13000/api/articles?page=${page}&per_page=${perPage}`;
    return fetchGet(url).then(res => {
      res.next_page = Number(res.next_page);
      res.per_page = Number(res.per_page);
      res.articles = res.articles.map(raw => new __WEBPACK_IMPORTED_MODULE_0__entity_article__["a" /* default */](raw));
      return res;
    }).catch(error => {
      throw error;
    });
  }
}
/* harmony export (immutable) */ __webpack_exports__["a"] = ArticleRepository;


function fetchGet(url) {
  return new Promise((resolve, reject) => {
    const req = new XMLHttpRequest();

    req.onreadystatechange = function () {
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

/***/ }),
/* 4 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
class Article {
  constructor(opts) {
    this.title = opts.title;
    this.body = opts.body;
    this.createdAt = opts.created_at; // TODO: js parse date
    this.updatedAt = opts.updated_at;
  }
}
/* harmony export (immutable) */ __webpack_exports__["a"] = Article;


/***/ }),
/* 5 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
class PagerView {
  constructor($element) {
    this.$container = $element;
    this.$pagination = this.$container.querySelector('.pagination');
    this.$prevButton = this.$pagination.querySelector('.prev-button');
    this.$nextButton = this.$pagination.querySelector('.next-button');
    this.$currentPage = this.$pagination.querySelector('.current-page');
    this.$pagination.addEventListener('click', e => {
      const perPage = Number(this.$pagination.getAttribute('data-per-page'));
      switch (e.target.className) {
        case 'prev-button':
          const $prevButton = this.$prevButton;
          const prevPage = Number($prevButton.getAttribute('data-prev-page'));
          const changeArticlePagePrevEvent = new CustomEvent('changeArticlePage', {
            detail: {
              perPage: perPage,
              page: prevPage
            }
          });
          document.dispatchEvent(changeArticlePagePrevEvent);
          break;
        case 'next-button':
          const $nextButton = this.$nextButton;
          const nextPage = Number($nextButton.getAttribute('data-next-page'));
          const changeArticlePageNextEvent = new CustomEvent('changeArticlePage', {
            detail: {
              perPage: perPage,
              page: nextPage
            }
          });
          document.dispatchEvent(changeArticlePageNextEvent);
          break;
        default:
          console.error(e);
      }
    });
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
    $prevButton.setAttribute('data-prev-page', nextPage - 2);

    const $currentPage = this.$currentPage;
    const $currentPageText = document.createTextNode(`page ${nextPage}`);
    $currentPage.innerHTML = '';
    $currentPage.appendChild($currentPageText);
  }

  render(perPage, nextPage) {
    this._paginationElement(perPage, nextPage);
  }
}
/* harmony export (immutable) */ __webpack_exports__["a"] = PagerView;


/***/ }),
/* 6 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
class ArticlesView {
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
    articles.forEach(article => {
      const $article = this._articleElement(article);
      this.$articles.appendChild($article);
    });
  }
}
/* harmony export (immutable) */ __webpack_exports__["a"] = ArticlesView;


/***/ })
/******/ ]);