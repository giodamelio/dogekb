path = require "path"

express = require "express"
bodyParser = require "body-parser"
jade = require "jade"

mongoose = require "mongoose"

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

# Handle the sobdomains
require("./subdomain")(app)


# Handle the api
app.use "/api", require("./api")

# Render the main angularjs site
app.get "/", (req, res) ->
    res.render "index"

console.log "App started"
app.listen Number(process.env.PORT or 3141)
