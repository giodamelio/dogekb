SiteModel = require "./models/site"

module.exports = (app) ->
    # If they are on a subdomain, serve their page
    app.use (req, res, next) ->
        if req.subdomain?
            SiteModel.findOne
                subdomain: req.subdomain
            , (error, site) ->
                if error then console.log error

                if site?
                    res.send site.content
                else
                    res.send "Invalid subdomain"
        else
            next()
