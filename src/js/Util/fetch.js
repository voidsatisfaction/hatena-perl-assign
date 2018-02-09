export function fetchGet(url) {
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
