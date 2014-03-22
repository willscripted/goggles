Goggles
===================

Simpler google api

Load api as promise. Only use client requests.

Install
-------------

```
bower install --save goggles
```

Usage
-----------

Include this on your page
```html
<script src="path/to/bower/googles-api"></script>
<script type="text/javascript">
  // Google APi Promise
  var gap = new Goggles({
    apiKey:   "SOME_API_KEY",
    clientId: "SOME_CLKENT_KEY"
    scopes: [
      'https://www.googleapis.com/auth/calendar.readonly'
    ]
  }); // => promise

  // Attach login to button if not automatically logged in
  $("button .google").click(api.login)
</script>
```

Then you can access an authenticated google api using the promise.
```javascript
// google api promise (gap)
// returns the `gapi`
gap.then(function(gapi){

  gapi.client.request({
    // stuff
  }).execute(function(){});

});
```


Mixin
------------

Add a `request` method to your `prototype`

### JavaScript

```javascipt
function Thing() {}
_.extend(Thing.prototype, Goggles.mixin)

```

### CoffeeScript

```coffeescript
class Calendar

  _.extend(this, Googles.mixin)

```

### Why

This will add a `request` method to your function's `prototype`.

Cleanly separates request object creation from execution.

```coffeescript

class Calendar
  _.extend(this, Goggles.mixin)

  events: (id, params = {}) ->
    {
      path: "cal/#{id}/events"
      method: "GET"
      params: _.defaults(params, {
        singleEvents: true
      })
    }

  getEvents: (opts) ->
    @request(@events("primary", opts))

cal = new Calendar();
events = cal.getEvents() # => promise for events

events.then((events) ->
  console.log(events) # => logs the result of your request
)

```

Allows you to keep tests independent of google's api

```
cal = new Calendar()

# Normalc api
cal.getEvents({things: "stuff"}) # => Q([list, of, tasks]

# Stub api
stub = sinon.stub(cal, "request")
         .returns(Q([some, stub, events]))

cal.getEvents({things: "stuff"}) # => Q([some, stub, events])
```

Contributing
---------------

Specs please.

License
---------

The MIT License (MIT)

Copyright (c) 2014 Will O'Brien
