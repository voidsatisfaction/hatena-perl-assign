export default class MouseStalker {
  constructor(opts) {
    if (!opts) {
      return
    }
    const { imageUrl, width, height, diffX, diffY, id } = opts;

    const $stalker = document.createElement('div');
    $stalker.setAttribute('id', `mouse-stalker-${id || 'element'}`);
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
      const x = `${e.pageX + (diffX || 15)}px`;
      const y = `${e.pageY + (diffY || 15)}px`;
      $stalker.style.left = x;
      $stalker.style.top = y;
    });

    this.$element = $stalker;
  }
}
