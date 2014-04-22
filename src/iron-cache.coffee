fs = require "fs"
request = require "request"

# Simple IronCache interface
# Example:
#   # Put a item
#   ironCache.put "haha", "random site here", (result) ->
#       console.log "Put item", result
#
#   # Get an item
#   ironCache.get "haha", (result) ->
#       console.log "Got item", result
#
#   # Delete an item
#   ironCache.delete "test", (result) ->
#       console.log "Deleted item", result
#
#   # Clear the ENTIRE cache
#   ironCache.clear (result) ->
#       console.log "Cleared ENTIRE cache"
#

module.exports = class
    baseUrl: "https://cache-aws-us-east-1.iron.io/1"

    constructor: (@cacheName, configFile) ->
        @config = JSON.parse(fs.readFileSync(configFile).toString())

    put: (key, value, callback) =>
        request(
            url: @baseUrl + "/projects/#{@config.project_id}/caches/#{@cacheName}/items/#{key}"
            method: "PUT"
            headers:
                "Authorization": "OAuth #{@config.token}"
            json:
                value: value
        , (error, response, body) ->
            if error then console.log error
            callback JSON.parse(body)
        )

    get: (key, callback) =>
        request(
            url: @baseUrl + "/projects/#{@config.project_id}/caches/#{@cacheName}/items/#{key}"
            method: "GET"
            headers:
                "Authorization": "OAuth #{@config.token}"
        , (error, response, body) ->
            if error then console.log error
            callback JSON.parse(body)
        )

    delete: (key, callback) =>
        request(
            url: @baseUrl + "/projects/#{@config.project_id}/caches/#{@cacheName}/items/#{key}"
            method: "DELETE"
            headers:
                "Authorization": "OAuth #{@config.token}"
        , (error, response, body) ->
            if error then console.log error
            callback JSON.parse(body)
        )

    clear: (callback) =>
        request(
            url: @baseUrl + "/projects/#{@config.project_id}/caches/#{@cacheName}/clear"
            method: "POST"
            headers:
                "Authorization": "OAuth #{@config.token}"
        , (error, response, body) ->
            if error then console.log error
            callback JSON.parse(body)
        )
