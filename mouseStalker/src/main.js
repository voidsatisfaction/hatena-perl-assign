export default class MouseStalker {
  constructor(opts) {
    const { imageUrl, width, height } = opts;
    const $stalker = document.createElement('div');
    $stalker.setAttribute('id', 'mouse-stalker-element');
    $stalker.style.position = 'absolute';
    $stalker.style.display = 'inline-block';
    $stalker.style.width = `${width || '30px'}`;
    $stalker.style.height = `${height || '30px'}`;
    if (imageUrl) {
      $stalker.style.backgroundImage = `url(${imageUrl})`;
    } else {
      $stalker.style.backgroundColor = "red";
    }
    $stalker.style.backgroundSize = 'cover';
    $stalker.style.backgroundRepeat = 'no-repeat';
    document.body.append($stalker);

    document.addEventListener('mousemove', (e) => {
      const x = `${e.x + 15}px`;
      const y = `${e.y + 15}px`;
      $stalker.style.left = x;
      $stalker.style.top = y;
    });

    this.$element = $stalker;
  }
}

if (module.hot) {
  module.hot.accept();
}
