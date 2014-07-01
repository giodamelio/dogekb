var express = require("express");

var app = module.exports = express.Router();

// Homepage
app.get("/", function(req, res) {
    res.render("index");
});

// Invalid subdomain
app.get("/invalid", function(req, res) {
    res.render("error", { code: "", error: "Invalid subdomain" });
});

// Catch errors
app.use(function(req, res, next) {
    if (req.subdomains.length > 1) {
        res.redirect("/invalid");
    } else {
        res.render("error", { code: 404, error: "Page not found" });
    }
});

