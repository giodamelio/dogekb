path = require "path"

express = require "express"
jade = require "jade"
mongoose = require "mongoose"
bodyParser = require "body-parser"

# Get our models
SiteModel = require "./models/site"

# Make our express app
app = express()

# Setup some middleware
app.use bodyParser()

# Setup our views
app.set "view engine", "jade"
app.engine "jade", jade.__express

# Serve our static stuff
app.use express.static(path.resolve(__dirname, "../static"))

# Connect to mongoose
mongoose.connect process.env.MONGOHQ_URL

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
        SiteModel.findOne
            subdomain: req.subdomain
        , (error, site) ->
            if error then console.log error

            if site?
                res.send site.content
            else
                res.send "Invalid subdomain"
    else
        next()

# If they are not on a subdomain, serve the main site
app.get "/", (req, res) ->
    res.render "index"

app.post "/add", (req, res) ->
    site = new SiteModel
        subdomain: req.body.subdomain
        content: req.body.content
    site.save (error) ->
        if error then console.log error
        res.send "Added"

console.log "App started"
app.listen Number(process.env.PORT || 3141)
