Goggles
===================

9 out of 10 optometrists agree, looking directly at the [init code](https://code.google.com/p/google-api-javascript-client/source/browse/samples/authSample.html) of [google's client api](https://code.google.com/p/google-api-javascript-client/) may result in irreversable damage.

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
    scope: [
      'https://www.googleapis.com/auth/calendar.readonly'
    ]
  }); // => promise

  // Attach login to button if not automatically logged in
  $("button .google").click(gap.login)
</script>
```

The `apiKey` allows your app to access public data.   
The `clientId` is the id that the user is authorizing to access their public data.   
The `scope` is a set of permissions that the user is granting to the `clientId`.   


```javascript
// google api promise (gap)
// returns the `gapi`
gap.then(function(gapi){

  gapi.client.request({
    // request params
  }).execute(function(){});

});
```


API
------------

### Methods

`then(fn)`

Where fn is a function of signature `function (googleApi)`

`login()`

Method to prompt the user to allow oauth access.

**Note** - This must be done syncronously on a button click to prevent the popup from being blocked

`wasImmediatelyAuthorizable()`

Whether the user's token could be retreived withou user input.

Contributing
---------------

Specs please.

License
---------

The MIT License (MIT)

Copyright (c) 2014 Will O'Brien
