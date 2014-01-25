authorization = require './authorization'
express = require 'express'
db = require './datalayer'
_ = require 'underscore'
cors = require 'cors'

port = process.env.PORT or 3000

SERVER_PREFIX = "http://localhost:#{port}"
app = express()
app.use cors()
app.use express.logger()
app.use express.bodyParser()
app.use express.cookieParser()
app.use express.methodOverride()
app.use express.cookieSession(secret: 'keyboard cat blah')
authorization app, SERVER_PREFIX
app.use app.router

requireAuthentication = (req, res, next) ->
  return res.json('401', error: 'Not logged in') unless req.user
  next()

app.all '/api/*', requireAuthentication

sendUserJson = (user, res) ->
app.get '/api/user', (req, res, next) ->
  res.json req.user.getPublicData()

app.put '/api/user', (req, res, next) ->
  req.user.setPublicData req.body
  req.user.save().done (err, user) ->
    return res.json '400', error: err if err
    res.json user.getPublicData()


db.init ->
  app.listen port
console.log "App started on port " + port