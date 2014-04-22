express = require "express"

IronCache = require "./iron-cache"

# Make our express app
app = express()

# Make our iron-cache instence
ironCache = new IronCache "site_data", "iron.json"

# Check to see if we are on a subdomain
app.use (req, res) ->
    rootHosts = ["localhost:3141"]

    if req.headers.host in rootHosts
        res.send "You are at root"
    else
        res.send "You are at a subdomain: " + req.headers.host.split(".")[0]

console.log "App started"
app.listen Number(process.env.PORT || 3141)
