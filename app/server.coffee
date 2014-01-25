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
app.use express.cookieParser()
app.use express.methodOverride()
app.use express.cookieSession(secret: 'keyboard cat blah')
authorization app, SERVER_PREFIX
app.use app.router

app.get '/api/user', (req, res, next) ->
  return res.json('401', error: 'Not logged in') unless req.user
  res.json _.pick req.user.values, req.user.readAttributes()

app.put '/api/user', (req, res, next) ->


db.init ->
  app.listen port
console.log "App started on port " + port