var path = require("path");

var express = require("express");
var expressSubdomainHandler = require("express-subdomain-handler");

var app = express();

// Map subdomains to routes
app.use(expressSubdomainHandler({
    baseUrl: "localhost.com:3141",
    prefix: "subdomain"
}));

// Handle subdomain
app.get("/subdomain/:subdomain", function(req, res) {
    res.send("Subdomain: " + req.params.subdomain);
});

// Homepage
app.get("/", function(req, res) {
    res.send("Hello World!!!");
});

// Invalid subdomain
app.get("/invalid", function(req, res) {
    res.send("Invalid subdomain");
});

// Page not found
app.use(function(req, res, next) {
    res.send("404 Page not found");
});

var port = Number(process.env.PORT || 3141);
app.listen(port, function() {
    console.log("App running on port", port);
});

