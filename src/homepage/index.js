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


