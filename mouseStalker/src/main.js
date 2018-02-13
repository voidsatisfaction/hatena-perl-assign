import MouseStalker from './mouseStalker';

import './main.css';

new MouseStalker({
  width: '50px',
  height: '50px',
  imageUrl: 'https://cdn.worldvectorlogo.com/logos/gopher.svg'
});

const $mouseStalker2 = new MouseStalker({
  width: '50px',
  height: '50px',
  diffX: 50,
  diffY: 70,
  id: 'cocomon',
  imageUrl: '/mad.png'
});

if (module.hot) {
  module.hot.accept();
}
