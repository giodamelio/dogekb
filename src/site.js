var express = require("express");

var app = module.exports = express.Router();

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

