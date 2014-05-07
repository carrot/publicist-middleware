basicAuth = require 'basic-auth'

###*
 * Configures options and returns a middleware function.
 *
 * Options:
 * - auth: A basic auth user/pass in the format of 'user:password'.
 *
 * @param  {Object} opts - options object, described above
 * @return {Function} middleware function
###

module.exports = (opts = {}) ->
  opts =
    auth: opts.auth

  return (req, res, next) ->
    if not opts.auth then return next()

    if JSON.stringify(basicAuth(req)) == format_auth_option(opts.auth)
      next()
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
