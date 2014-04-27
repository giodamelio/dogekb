passport = require "passport"
LocalStrategy = require("passport-local").Strategy

# Get our models
SiteModel = require "./models/site"
UserModel = require "./models/user"

# Setup passport LocalStrategy
passport.use new LocalStrategy(
    usernameField: "email"
, (email, password, done) ->
    UserModel.findOne
        email: email
    , (error, user) ->
        if error then return done(error)

        # Check if user exists
        if not user
            return done(null, false, message: "Incorrect username")

        # Compare the passwords
        user.comparePassword password, (error, isMatch) ->
            if error then return done(error)

            if isMatch
                # Password is good
                return done(null, user)
            else
                # Password is bad
                return done(null, false, message: "Incorrect password")
)

module.exports = (app) ->
    # Setup routes for our LocalStrategy
    app.post "/login/local", passport.authenticate("local",
        successRedirect: "/"
        failureRedirect: "/login"
        failureFlash: true
    )

    # Setup universal logout
    app.post "/logout", (req, res) ->
        req.logout()
        res.redirect "/"
