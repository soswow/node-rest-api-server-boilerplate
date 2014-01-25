passport = require 'passport'
FacebookStrategy = require('passport-facebook').Strategy
LinkedInStrategy = require('passport-linkedin').Strategy
secrets = require './secrets'
db = require './datalayer'

module.exports = (app, baseUrl) ->
  app.use passport.initialize()
  app.use passport.session()

  # set up passport-facebook
  fbCallbackUrl = '/auth/facebook/callback'
  app.use '/auth/facebook', passport.authenticate("facebook", scope: ['email'], failureRedirect: '/', successRedirect: '/api/user')

  passport.use new FacebookStrategy(
    clientID: secrets.FB_APPID
    clientSecret: secrets.FB_APPSECRET
    sessionKey: 'facebookOauth'
    callbackURL: baseUrl + fbCallbackUrl
  , (accessToken, refreshToken, profile, done) ->
    console.log "accessToken=" + accessToken + " facebookId=" + profile.id
    done null, profile
  )

  liCallbackUrl = '/auth/linkedin/callback'
  app.use '/auth/linkedin',
    passport.authenticate "linkedin",
      scope: ['r_basicprofile', 'r_emailaddress']
      failureRedirect: '/'
      successRedirect: '/api/user'

  passport.use new LinkedInStrategy(
    consumerKey: secrets.LI_APPID
    consumerSecret: secrets.LI_APPSECRET
    sessionKey: 'linkedinOauth'
    profileFields: ['id', 'first-name', 'last-name', 'email-address', 'headline']
    callbackURL: baseUrl + liCallbackUrl
  , (accessToken, refreshToken, profile, done) ->
    console.log "accessToken=" + accessToken + " linkedIn=" + profile.id
    done null, profile
  )

  passport.serializeUser (profile, done) ->
    db.User.findOrCreate(email: profile.emails[0].value).done (err, user) ->
      return done(err) if err
      user.name = profile.displayName
      user.data =
        profile.provider:
          id: profile.id
      user.save().done (err) -> done err, user.id

  passport.deserializeUser (id, done) ->
    db.User.find(id).done done

  app.get '/logout', (req, res) ->
    req.logout()
    res.redirect '/'

  return passport