Q = require('q')

Goggles = {
  mixin: {
    request: (requestConstructor, args...) ->
      def = Q.defer()
      @api.then((api) ->
        api.client.request(eventsRequest.apply(this, arguments)).execute((results) ->
          def.resolve(results)
        )
      )
      return def.promise
  }
}
