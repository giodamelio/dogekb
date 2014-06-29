var path = require("path");

var express = require("express");
var expressSubdomainHandler = require("express-subdomain-handler");

var app = express();

// Setup jade
app.set("view engine", "jade");
app.set("views", path.resolve(__dirname, "../views"));

// Serve static files
app.use(express.static(path.resolve(__dirname, "../public")));

// Handle subdomains
app.use(require("./subdomain"));

// Handle site
app.use(require("./site"));

var port = Number(process.env.PORT || 3141);
app.listen(port, function() {
    console.log("App running on port", port);
});

