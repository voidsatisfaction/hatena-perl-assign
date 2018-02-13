import mouseStalker from './mouseStalker/mouseStalker';

import './main.css';

document.addEventListener('mousemove', (e) => {
  const stalker = document.querySelector('#stalker');
  const x = `${e.x}px`;
  const y = `${e.y}px`;
  stalker.style.left = x;
  stalker.style.top = y;
});


if (module.hot) {
  module.hot.accept();
}
