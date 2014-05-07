basicAuth = require 'basic-auth'
minimatch = require 'minimatch'
_         = require 'lodash'

###*
 * Configures options and returns a middleware function.
 *
 * Options:
 * - auth: A basic auth user/pass in the format of 'user:password'.
 *
 * @param  {Object} opts - options object, described above
 * @return {Function} middleware function
###

module.exports = (opts) ->
  if typeof opts == 'string'
    match = {'**': opts}
  else if typeof opts == 'object' and opts.hasOwnProperty('user')
    match = {'**': opts.user + ':' + opts.pass}
  else
    match = opts

  return (req, res, next) ->
    if not opts then return next()
    _.keys(match).some (matcher) =>
      @match = if minimatch(req.url, matcher) then matcher else false

    # the current route did not match a globstar, carry on
    if not @match then return next()

    # check if auth_headers are accurate, otherwise prompt authentication
    auth_headers = JSON.stringify(basicAuth(req))
    if auth_headers == format_auth_option(match[@match])
      return next()
    else
      res.statusCode = 401
      res.setHeader('WWW-Authenticate', 'Basic realm="Secure Area"')
      res.end('Not Authorized')

###*
 * Formats auth credentials to follow the {name: 'user', pass: 'pass'}
 * format of node-basic-auth
 *
 * @private
 * @param  {String} auth - a username:password string
 * @return {String} a stringified JSON object with 'name' and 'pass' keys
###

format_auth_option = (auth) ->
  auth = auth.split(':')
  JSON.stringify({ name: auth[0], pass: auth[1] })
