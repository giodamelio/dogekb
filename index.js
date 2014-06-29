var path = require("path");

var express = require("express");
var expressSubdomainHandler = require("express-subdomain-handler");

var app = express();

// Setup jade
app.set("view engine", "jade");
app.set("views", __dirname + "/views");

// Serve static files
app.use(express.static(__dirname + "/public"));

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
    res.render("index");
});

// Invalid subdomain
app.get("/invalid", function(req, res) {
    res.send("Invalid subdomain");
});

// Page not found
app.use(function(req, res, next) {
    res.render("error", { code: 404, error: "Page not found" });
});

var port = Number(process.env.PORT || 3141);
app.listen(port, function() {
    console.log("App running on port", port);
});

