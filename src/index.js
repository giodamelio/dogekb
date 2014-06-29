var path = require("path");

var express = require("express");

var app = express();

// Setup jade
app.set("view engine", "jade");
app.set("views", path.resolve(__dirname, "../views"));

// Serve static files
app.use(express.static(path.resolve(__dirname, "../public")));

// Modify req.redirect so it sends to root domain
app.use(function(req, res, next) {
    res.redirectOld = res.redirect;
    res.redirect = function(url) {
        res.redirectOld(process.env.DOMAIN_PREFIX + url);
    };
    next();
});

// Handle subdomains
app.use(require("./subdomain"));

// Handle site
app.use(require("./site"));

var port = Number(process.env.PORT || 3141);
app.listen(port, function() {
    console.log("App running on port", port);
});

