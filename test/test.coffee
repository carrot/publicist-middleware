connect     = require 'connect'

before ->
  @path = path.join(base_path, 'basic')

describe 'basic', ->

  it 'should be registered as middleware', ->
    (-> connect().use(publicist())).should.not.throw()

  it 'should skip basic auth if no auth option is provided', (done) ->
    @app = connect()
            .use(publicist())
            .use(connect.static(@path))

    chai.request(@app).get('/index.html').res (res) ->
      res.should.have.status(200)
      res.should.be.html
      res.text.should.equal("<p>hello world!</p>\n")
      done()

describe 'string option', ->

  it 'should prompt basic auth and stop request', (done) ->
    auth = 'Basic ' + new Buffer('user:wrongpass').toString('base64')
    @app = connect()
            .use((req, res, next) -> req.headers.authorization = auth; next())
            .use(publicist('user:pass'))
            .use(connect.static(@path))

    chai.request(@app).get('/index.html').res (res) ->
      res.should.have.status(401)
      done()

  it 'should continue request when correct creds are passed', (done) ->
    auth = 'Basic ' + new Buffer('user:pass').toString('base64')
    @app = connect()
            .use((req, res, next) -> req.headers.authorization = auth; next())
            .use(publicist('user:pass'))
            .use(connect.static(@path))

    chai.request(@app).get('/index.html').res (res) ->
      res.should.have.status(200)
      res.should.be.html
      res.text.should.equal("<p>hello world!</p>\n")
      done()

describe 'user/pass object', ->

  it 'should prompt basic auth and stop request', (done) ->
    auth = 'Basic ' + new Buffer('user:wrongpass').toString('base64')
    @app = connect()
            .use((req, res, next) -> req.headers.authorization = auth; next())
            .use(publicist(user: 'foo', pass: 'bar'))
            .use(connect.static(@path))

    chai.request(@app).get('/index.html').res (res) ->
      res.should.have.status(401)
      done()

  it 'should continue request when correct creds are passed', (done) ->
    auth = 'Basic ' + new Buffer('foo:bar').toString('base64')
    @app = connect()
            .use((req, res, next) -> req.headers.authorization = auth; next())
            .use(publicist(user: 'foo', pass: 'bar'))
            .use(connect.static(@path))

    chai.request(@app).get('/index.html').res (res) ->
      res.should.have.status(200)
      res.should.be.html
      res.text.should.equal("<p>hello world!</p>\n")
      done()

describe 'route matching', ->

  it 'should prompt basic auth and stop request for matched route', (done) ->
    @app = connect()
            .use(publicist(
              '/protected/**': 'user:pass',
              '/also-protected/*': 'foo:bar'
            ))
            .use(connect.static(@path))

    chai.request(@app).get('/protected/index.html').res (res) ->
      res.should.have.status(401)
      done()

  it 'should continue request when match & correct creds are passed', (done) ->
    auth = 'Basic ' + new Buffer('foo:bar').toString('base64')
    @app = connect()
            .use((req, res, next) -> req.headers.authorization = auth; next())
            .use(publicist('/protected/**': 'foo:bar'))
            .use(connect.static(@path))

    chai.request(@app).get('/protected/index.html').res (res) ->
      res.should.have.status(200)
      res.should.be.html
      res.text.should.equal("<p>protected index</p>\n")
      done()

  it 'should allow proper passage to an unmatched route', (done) ->
    @app = connect()
            .use(publicist(
              '/protected/**': 'user:pass',
              '/also-protected/*': 'foo:bar'
            ))
            .use(connect.static(@path))

    chai.request(@app).get('/nested/index.html').res (res) ->
      res.should.have.status(200)
      res.should.be.html
      res.text.should.equal("<p>nested index</p>\n")
      done()
