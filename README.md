# Publicist Middleware

[![npm](http://img.shields.io/npm/v/publicist-middleware.svg?style=flat)](https://badge.fury.io/js/publicist-middleware) [![tests](http://img.shields.io/travis/carrot/publicist-middleware/master.svg?style=flat)](https://travis-ci.org/carrot/publicist-middleware) [![dependencies](http://img.shields.io/gemnasium/carrot/publicist-middleware.svg?style=flat)](https://david-dm.org/carrot/publicist-middleware)

locking static sites down since 1888

> **Note:** This project is in early development, and versioning is a little different. [Read this](http://markup.im/#q4_cRZ1Q) for more details.

### Why should you care?

Let's be clear here, HTTP Basic Auth isn't the most secure thing in the world, but many times it's all you really need. Whether you're staging a site for a private audience or hiding a couple trade secrets adding a username and password to your static site should be easy. Simply provide Publicist a `username:password` string and we'll do the heavy lifting.

### Installation

`npm install publicist-middleware --save`

### Usage

This library can be used with connect, express, and any other server stack that accepts the same middleware format. A very basic usage example:

```js
var http = require('http');
    connect = require('connect'),
    publicist = require('publicist-middleware');

var app = connect()
  .use(publicist(auth: 'username:password')
  .use(connect.static('public'));

var server = http.createServer(app).listen(1111)
```

### License & Contributing

- Details on the license [can be found here](LICENSE.md)
- Details on running tests and contributing [can be found here](contributing.md)
