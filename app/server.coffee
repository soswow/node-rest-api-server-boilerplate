authorization = require './authorization'
express = require 'express'
db = require './datalayer'

port = process.env.PORT or 3000

SERVER_PREFIX = "http://localhost:#{port}"
app = express()
app.use express.cookieParser()
app.use express.bodyParser()
app.use express.session secret: 'keyboard cat blah'
authorization app, SERVER_PREFIX
app.use app.router

app.get '/api/user', (req, res, next) ->
  res.end req.user.values

db.init ->
  app.listen port
console.log "App started on port " + port