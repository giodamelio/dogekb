var mongoose = require("mongoose");
var ms = require("ms");
var uuid = require("mongoose-uuid");

var siteSchema = mongoose.Schema({
    subdomain: {
        type: String,
        required: true,
        unique: true
    },
    expires: {
        type: Date,
        required: true,
        default: function() {
            return Date.now() + ms("1d");
        }
    },
    email: {
        type: String,
        unique: true,
        sparse: true
    },
    uuid: String
}, {
    _id: false
});

// Replace the id with a uuid
siteSchema.plugin(uuid.plugin);

var siteModel = module.exports = mongoose.model("Site", siteSchema);

//siteModel.methods = function
