IronCache = require "../src/iron-cache"

# Get the cache name from the arguments
if process.argv.length < 2
    console.log "You must provide a cache name to clear"
    console.log "coffee scripts/clearCache.coffee [cacheName]"
    process.exit()
else
    name = process.argv[2]
    

# Make our iron-cache instence
ironCache = new IronCache name, "iron.json"

ironCache.clear (response) ->
    console.log "Cache Cleared"
