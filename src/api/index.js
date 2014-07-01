var express = require("express");

var app = module.exports = express.Router();

app.get("/", function(req, res) {
    res.send("Hello API");
});

