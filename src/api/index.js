var express = require("express");
var mongoose = require("mongoose");

var Site = require("../models/site");

var app = module.exports = express.Router();

app.get("/", function(req, res) {
    res.send("Hello API");
});

app.post("/site", function(req, res) {
    site = new Site(req.body);
    site.save(function(err, site) {
        if (err) console.log(err);
        res.send(site);
    });
});

