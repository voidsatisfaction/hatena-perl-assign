const path = require('path');

const config = {
  entry: [
    './src/js/main.js',
  ],
  output: {
    path: path.join(__dirname, 'static/js'),
    filename: 'main.js',
  },
  module: {
    loaders: [{
      test: /\.js$/,
      loaders: ['babel-loader'],
      include: path.join(__dirname, 'src/js'),
    }],
  },
};

module.exports = config;
