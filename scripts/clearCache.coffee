IronCache = require "../src/iron-cache"

# Get the cache name from the arguments
if process.argv.length < 2
    console.log "You must provide a cache name to clear"
    console.log "coffee scripts/clearCache.coffee [cacheName]"
    process.exit()
else
    name = process.argv[2]
    

# Make our iron-cache instence
ironCache = new IronCache("site_data", process.env.IRON_CACHE_TOKEN, process.env.IRON_CACHE_PROJECT_ID)

ironCache.clear (response) ->
    console.log "Cache Cleared"
