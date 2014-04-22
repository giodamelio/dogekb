express = require "express"

IronCache = require "./iron-cache"

# Make our express app
app = express()

# Make our iron-cache instence
ironCache = new IronCache("site_data", process.env.IRON_CACHE_TOKEN, process.env.IRON_CACHE_PROJECT_ID)

# Check to see if we are on a subdomain
app.use (req, res, next) ->
    rootHosts = ["www.dogekb.com", "dogekb.com", "localhost:3141", "www.localhost:3141"]
    if req.headers.host in rootHosts
        # They are visiting the main site
        # Let the main handler catch it
    else
        # They are visiting a subdomain
        # Add a key to the request so we know
        req.subdomain = req.headers.host.split(".")[0]

    next()

# If they are on a subdomain, serve their page
app.use (req, res, next) ->
    if req.subdomain?
        ironCache.get req.subdomain, (body) ->
            # If the subdomain is valid, send the data
            # Otherwise send an error message
            if body.msg == "Key not found."
                res.send "Invalid subdomain"
            else
                res.send body.value
    else
        next()

# If they are not on a subdomain, serve the main site
app.get "/", (req, res) ->
    res.send "Main Site Goes Here"

console.log "App started"
app.listen Number(process.env.PORT || 3141)
