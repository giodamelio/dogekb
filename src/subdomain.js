var express = require("express");
var expressSubdomainHandler = require("express-subdomain-handler");

var app = module.exports = express.Router();

// Map subdomains to routes
app.use(expressSubdomainHandler({
    baseUrl: "localhost.com:3141",
    prefix: "subdomain"
}));

// Handle subdomain
app.get("/subdomain/:subdomain", function(req, res) {
    res.send("Subdomain: " + req.params.subdomain);
});

