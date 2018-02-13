const path = require('path');
const webpack = require('webpack');

const config = {
  entry: [
    path.resolve(__dirname, 'src/main.js')
  ],
  module: {
    rules: [{
      test: /\.css$/,
      use: [
        'style-loader',
        'css-loader?url=false',
      ]
    }, {
      test: /\.js$/,
      exclude: /node_modules/,
      use: [{
        loader: 'babel-loader',
        options: {
          presets: [
            ['es2015', {modules: false}]
          ]
        }
      }]
    }, {
      test: /\.png$/,
      use: [
        'url-loader',
      ]
    }],
  },
  plugins: [
    new webpack.NamedModulesPlugin(),
  ],
  output: {
    filename: 'main.js',
    path: path.resolve(__dirname, 'dist')
  },
  devServer: {
    contentBase: 'dist',
    port: 8080
  },
};

module.exports = config;
