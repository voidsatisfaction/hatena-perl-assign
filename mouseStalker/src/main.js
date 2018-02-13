import MouseStalker from './mouseStalker';

import './main.css';

new MouseStalker({
  width: '50px',
  height: '50px',
  imageUrl: 'https://cdn.worldvectorlogo.com/logos/gopher.svg'
});

if (module.hot) {
  module.hot.accept();
}
