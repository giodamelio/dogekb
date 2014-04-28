expressJwt = require "express-jwt"
jsonwebtoken = require "jsonwebtoken"

UserModel = require "./models/user"

module.exports = (app) ->
    # Protect all the routes under /api
    app.use "/api", expressJwt(secret: process.env.TOKEN_SECRET)

    # Login and get token
    app.post "/auth/login", (req, res) ->
        UserModel.findOne { email: req.body.email }, (error, user) ->
            if error then console.log error

            # Send a unauthorized message if the user does not exist
            if not user
                res.json 401, { message: "User does not exist" }
                return

            # Check to see if our passwords match
            user.comparePassword req.body.password, (error, isMatch) ->
                if error then console.log error

                if isMatch
                    # Account it good

                    # Sign our token and set it to expire in 5 hours
                    token = jsonwebtoken.sign({ email: user.email }, process.env.TOKEN_SECRET, { expiresInMinutes: 60 * 5 })

                    res.json
                        token: token
                        message: "Successfully logged in"
                else
                    # Wrong password
                    res.json 401, { message: "Incorrect Password" }

    # Signup and get token
    app.post "/auth/signup", (req, res) ->
        user = new UserModel
            email: req.body.email
            password: req.body.password

        user.save (error) ->
            if error
                # Check if email is already taken
                if error.code == 11000
                    res.json 401, { message: "Email is taken" }
                    return

            # Sign our token and set it to expire in 5 hours
            token = jsonwebtoken.sign({ email: req.body.email }, process.env.TOKEN_SECRET, { expiresInMinutes: 60 * 5 })

            res.json
                token: token
                message: "User successfully created"