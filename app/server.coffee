restify = require 'restify'
passport = require 'passport'
FacebookStrategy = require('passport-facebook').Strategy
secrets = require './secrets'

port = process.env.PORT or 3000

# config vars
FB_LOGIN_PATH = "/api/facebook_login"
FB_CALLBACK_PATH = "/api/facebook_callback"
SERVER_PREFIX = "http://localhost:#{port}"

# set up server
server = restify.createServer()
server.use restify.queryParser()
server.use passport.initialize()

# set up passport-facebook
server.get FB_LOGIN_PATH, passport.authenticate("facebook", session: true)
server.get FB_CALLBACK_PATH, passport.authenticate("facebook", session: true),
  (req, res) ->
    console.log "we b logged in!"
    console.dir req.user
    res.send 'Welcome ' + req.user.displayName

passport.use new FacebookStrategy(
  clientID: secrets.FB_APPID
  clientSecret: secrets.FB_APPSECRET
  callbackURL: SERVER_PREFIX + FB_CALLBACK_PATH
, (accessToken, refreshToken, profile, done) ->
  console.log "accessToken=" + accessToken + " facebookId=" + profile.id
  done null, profile
)

passport.serializeUser (user, done) ->
  done null, JSON.stringify(user) #TODO Should save only ID

passport.deserializeUser (id, done) ->
  done null, JSON.parse(id) #TODO Should read from DB by ID


# Start the app by listening on <port>
server.listen port
console.log "App started on port " + port