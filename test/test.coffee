connect     = require 'connect'

describe 'basic', ->

  before ->
    @path = path.join(base_path, 'basic')

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

  it 'should prompt basic auth and stop request', (done) ->
    auth = 'Basic ' + new Buffer('user:wrongpass').toString('base64')
    @app = connect()
            .use((req, res, next) -> req.headers.authorization = auth; next())
            .use(publicist(auth: 'user:pass'))
            .use(connect.static(@path))

    chai.request(@app).get('/index.html').res (res) ->
      res.should.have.status(401)
      done()

  it 'should continue request when correct creds are passed', (done) ->
    auth = 'Basic ' + new Buffer('user:pass').toString('base64')
    @app = connect()
            .use((req, res, next) -> req.headers.authorization = auth; next())
            .use(publicist(auth: 'user:pass'))
            .use(connect.static(@path))

    chai.request(@app).get('/index.html').res (res) ->
      res.should.have.status(200)
      res.should.be.html
      res.text.should.equal("<p>hello world!</p>\n")
      done()
