!function(e){function t(r){if(n[r])return n[r].exports;var a=n[r]={i:r,l:!1,exports:{}};return e[r].call(a.exports,a,a.exports,t),a.l=!0,a.exports}var n={};t.m=e,t.c=n,t.d=function(e,n,r){t.o(e,n)||Object.defineProperty(e,n,{configurable:!1,enumerable:!0,get:r})},t.n=function(e){var n=e&&e.__esModule?function(){return e.default}:function(){return e};return t.d(n,"a",n),n},t.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)},t.p="",t(t.s=0)}([function(e,t,n){e.exports=n(1)},function(e,t,n){"use strict";var r=n(2),a=function(e){return e&&e.__esModule?e:{default:e}}(r);!function(){var e=document.querySelector(".articles-container");new a.default(e)}()},function(e,t,n){"use strict";function r(e){return e&&e.__esModule?e:{default:e}}function a(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}Object.defineProperty(t,"__esModule",{value:!0});var i=function(){function e(e,t){for(var n=0;n<t.length;n++){var r=t[n];r.enumerable=r.enumerable||!1,r.configurable=!0,"value"in r&&(r.writable=!0),Object.defineProperty(e,r.key,r)}}return function(t,n,r){return n&&e(t.prototype,n),r&&e(t,r),t}}(),u=n(3),o=r(u),c=n(6),l=r(c),s=n(7),f=r(s),p=function(){function e(t){a(this,e),this.$element=t,this.articleView=new f.default(this.$element),this.pagerView=new l.default(this.$element),this.articles=[],document.addEventListener("changeArticlePage",this.changeArticlePage.bind(this)),this.updateArticlesAndRender()}return i(e,[{key:"updateArticlesAndRender",value:function(e,t){var n=this;this._updateArticlesAndPagenationState(e,t).then(function(){n.articleView.render(n.articles,n.perPage,n.nextPage),n.pagerView.render(n.perPage,n.nextPage)}).catch(function(e){console.error(e)})}},{key:"changeArticlePage",value:function(e){var t=e.detail.page,n=e.detail.perPage;this.updateArticlesAndRender(t,n)}},{key:"_updateArticlesAndPagenationState",value:function(e,t){var n=this,r={page:e,perPage:t};return(new o.default).fetchArticlesWithPagination(r).then(function(e){n.articles=e.articles,n.nextPage=e.next_page,n.perPage=e.per_page}).catch(function(e){return e})}}]),e}();t.default=p},function(e,t,n){"use strict";function r(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}Object.defineProperty(t,"__esModule",{value:!0});var a=function(){function e(e,t){for(var n=0;n<t.length;n++){var r=t[n];r.enumerable=r.enumerable||!1,r.configurable=!0,"value"in r&&(r.writable=!0),Object.defineProperty(e,r.key,r)}}return function(t,n,r){return n&&e(t.prototype,n),r&&e(t,r),t}}(),i=n(4),u=function(e){return e&&e.__esModule?e:{default:e}}(i),o=n(5),c=function(){function e(){r(this,e)}return a(e,[{key:"fetchArticlesWithPagination",value:function(e){e||(e={});var t=e.page||0,n=e.perPage||10,r="http://localhost:13000/api/articles?page="+t+"&per_page="+n;return(0,o.fetchGet)(r).then(function(e){return e.next_page=Number(e.next_page),e.per_page=Number(e.per_page),e.articles=e.articles.map(function(e){return new u.default(e)}),e}).catch(function(e){throw e})}}]),e}();t.default=c},function(e,t,n){"use strict";function r(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}Object.defineProperty(t,"__esModule",{value:!0});var a=function e(t){r(this,e),this.title=t.title,this.body=t.body,this.createdAt=t.created_at,this.updatedAt=t.updated_at};t.default=a},function(e,t,n){"use strict";function r(e){return new Promise(function(t,n){var r=new XMLHttpRequest;r.onreadystatechange=function(){var e=r.response;if(4===r.readyState&&200===r.status){var a=JSON.parse(e);t(a)}404!==r.status&&403!==r.status&&500!==r.status||n(r.statusText)},r.open("GET",e),r.send()})}Object.defineProperty(t,"__esModule",{value:!0}),t.fetchGet=r},function(e,t,n){"use strict";function r(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}Object.defineProperty(t,"__esModule",{value:!0});var a=function(){function e(e,t){for(var n=0;n<t.length;n++){var r=t[n];r.enumerable=r.enumerable||!1,r.configurable=!0,"value"in r&&(r.writable=!0),Object.defineProperty(e,r.key,r)}}return function(t,n,r){return n&&e(t.prototype,n),r&&e(t,r),t}}(),i=function(){function e(t){var n=this;r(this,e),this.$container=t,this.$pagination=this.$container.querySelector(".pagination"),this.$prevButton=this.$pagination.querySelector(".prev-button"),this.$nextButton=this.$pagination.querySelector(".next-button"),this.$currentPage=this.$pagination.querySelector(".current-page"),this.$pagination.addEventListener("click",function(e){var t=Number(n.$pagination.getAttribute("data-per-page"));switch(e.target.className){case"prev-button":var r=n.$prevButton,a=Number(r.getAttribute("data-prev-page")),i=new CustomEvent("changeArticlePage",{detail:{perPage:t,page:a}});document.dispatchEvent(i);break;case"next-button":var u=n.$nextButton,o=Number(u.getAttribute("data-next-page")),c=new CustomEvent("changeArticlePage",{detail:{perPage:t,page:o}});document.dispatchEvent(c);break;default:console.error(e)}})}return a(e,[{key:"_paginationElement",value:function(e,t){var n=this.$pagination,r=this.$nextButton,a=this.$prevButton;n.setAttribute("data-per-page",e),1===t?a.setAttribute("hidden",!0):a.removeAttribute("hidden"),r.setAttribute("data-next-page",t),a.setAttribute("data-prev-page",t-2);var i=this.$currentPage,u=document.createTextNode("page "+t);i.innerHTML="",i.appendChild(u)}},{key:"render",value:function(e,t){this._paginationElement(e,t)}}]),e}();t.default=i},function(e,t,n){"use strict";function r(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}Object.defineProperty(t,"__esModule",{value:!0});var a=function(){function e(e,t){for(var n=0;n<t.length;n++){var r=t[n];r.enumerable=r.enumerable||!1,r.configurable=!0,"value"in r&&(r.writable=!0),Object.defineProperty(e,r.key,r)}}return function(t,n,r){return n&&e(t.prototype,n),r&&e(t,r),t}}(),i=function(){function e(t){r(this,e),this.$container=t,this.$articles=this.$container.querySelector(".articles")}return a(e,[{key:"_articleElement",value:function(e){var t=document.createElement("div"),n=document.createElement("h3"),r=document.createElement("p"),a=document.createTextNode(e.title),i=document.createTextNode(e.body);return n.appendChild(a),r.appendChild(i),t.appendChild(n),t.appendChild(r),t}},{key:"render",value:function(e,t,n){var r=this;this.$articles.innerHTML="",e.forEach(function(e){var t=r._articleElement(e);r.$articles.appendChild(t)})}}]),e}();t.default=i}]);