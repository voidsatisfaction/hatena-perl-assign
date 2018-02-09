const webpack = require('webpack');
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
      loader: 'babel-loader',
      include: path.join(__dirname, 'src/js'),
      query: {
        presets: ['es2015']
      }
    }],
  },
  plugins: [
    new webpack.optimize.UglifyJsPlugin(),
  ]
};

module.exports = config;
