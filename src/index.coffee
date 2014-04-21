express = require("express")
app = express()

# Check to see if we are on a subdomain
app.use (req, res) ->
    rootHosts = ["localhost:3141"]

    if req.headers.host in rootHosts
        res.send "You are at root"
    else
        res.send "You are at a subdomain: " + req.headers.host.split(".")[0]

console.log "App started on http://localhost:3141"
app.listen 3141
