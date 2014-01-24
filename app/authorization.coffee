passport = require 'passport'
FacebookStrategy = require('passport-facebook').Strategy
secrets = require './secrets'

module.exports = (app, baseUrl) ->

  callbackUrl = '/auth/facebook/callback'

  app.use passport.initialize()
  app.use passport.session()

  # set up passport-facebook
  app.use '/auth/facebook', passport.authenticate("facebook", {successRedirect: '/', failureRedirect: '/2'})
#  app.use callbackUrl, passport.authenticate("facebook", {successRedirect: '/', failureRedirect: '/2'})

  passport.use new FacebookStrategy(
    clientID: secrets.FB_APPID
    clientSecret: secrets.FB_APPSECRET
    callbackURL: baseUrl + callbackUrl
  , (accessToken, refreshToken, profile, done) ->
    console.log "accessToken=" + accessToken + " facebookId=" + profile.id
    done null, profile
  )

  passport.serializeUser (user, done) ->
    console.log('serializeUser')
    done null, user #TODO Should save only ID

  passport.deserializeUser (obj, done) ->
    console.log('deserializeUser')
    done null, obj #TODO Should read from DB by ID

  return passport