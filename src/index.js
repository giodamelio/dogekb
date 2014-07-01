var path = require("path");

var express = require("express");
var mongoose = require("mongoose");
var bodyParser = require("body-parser");

// Connect to the database
mongoose.connect(process.env.MONGOHQ_URL);

// Create our appp
var app = express();

// Setup jade
app.set("view engine", "jade");
app.set("views", path.resolve(__dirname, "../views"));

// Helpful middleware
app.use(bodyParser.json());

// Pass our base url to jade
app.locals.baseUrl = process.env.DOMAIN_PREFIX;

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

// Handle homepage
app.use(require("./homepage"));

// Handle api
app.use("/api", require("./api"));

// Handle errors
app.use(function(req, res, next) {
    if (req.subdomains.length > 1) {
        res.redirect("/invalid");
    } else {
        res.render("error", { code: 404, error: "Page not found" });
    }
});

var port = Number(process.env.PORT || 3141);
app.listen(port, function() {
    console.log("App running on port", port);
});

