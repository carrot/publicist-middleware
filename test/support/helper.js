var chai = require('chai'),
    http = require('chai-http'),
    path = require('path'),
    publicist = require('../..');

var should = chai.should();

chai.use(http);

global.publicist = publicist;
global.chai = chai;
global.should = should;
global.path = path;
global.base_path = path.join(__dirname, '../fixtures');
