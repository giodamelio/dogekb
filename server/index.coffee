path = require "path"

express = require "express"
bodyParser = require "body-parser"

harp = require "harp"

mongoose = require "mongoose"

# Make our express app
app = express()

# Setup some middleware
app.use bodyParser()

# Serve our static stuff
app.use express.static(path.resolve(__dirname, "../static"))

# Connect to mongoose
mongoose.connect process.env.MONGOHQ_URL

# Check to see if we are on a subdomain
app.use (req, res, next) ->
    rootHosts = ["www.dogekb.com", "dogekb.com", "localhost:3141", "www.localhost:3141"]
    if req.headers.host in rootHosts
        # They are visiting the main site
        # Let harp handle it
    else
        # They are visiting a subdomain
        # Add a key to the request so we know
        req.subdomain = req.headers.host.split(".")[0]

    next()

# Handle the sobdomains
require("./subdomain")(app)

# Handle authentication
require("./authentication")(app)

# Handle the api
app.use "/api", require("./api")

# Serve our client with harp
app.use harp.mount(path.resolve(__dirname, "../client"))

console.log "App started"
app.listen Number(process.env.PORT or 3141)
