express = require "express"

SiteModel = require "./models/site"
UserModel = require "./models/user"

api = module.exports = express.Router()

api.post "/add", (req, res) ->
    site = new SiteModel
        subdomain: req.headers.host.split(".")[0]
        content: req.body.content
    site.save (error) ->
        if error then console.log error
        res.send "Added"

# List all the subdomains
api.get "/list", (req, res) ->
    SiteModel.find {}, "subdomain content", (error, sites) ->
        res.send sites

# List all the users
api.get "/listusers", (req, res) ->
    UserModel.find {}, "subdomain content", (error, sites) ->
        res.send sites
