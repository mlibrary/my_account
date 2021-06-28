const path = require('path');
const ESLintPlugin = require('eslint-webpack-plugin');

module.exports = {
  entry: {
    main: './js/index.js',
    'current-checkouts-u-m-library': './js/current-checkouts.js',
    'fines-and-fees': './js/fines-and-fees.js',
    settings: './js/settings.js'
  },
  output: {
    filename: '[name].bundle.js',
    path: path.resolve(__dirname, 'public/bundles')
  },
  plugins: [new ESLintPlugin()]
};
