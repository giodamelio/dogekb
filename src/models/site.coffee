mongoose = require "mongoose"

module.exports = mongoose.model "Site",
    subdomain:
        type: String
        unique: true
    content:
        type: String
