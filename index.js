var express = require("express");

var app = express();

app.get("/", function(req, res) {
    res.send("Hello World!!!");
});

var port = Number(process.env.PORT || 3141);
app.listen(port, function() {
    console.log("App running on port", port);
});

