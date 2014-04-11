<p align="center">
  <img width="320px" height="320px" src="https://raw.githubusercontent.com/will-ob/goggles/master/goggles.png" />
</p>
<p align="center">Image by <a href="https://www.flickr.com/photos/neilt/10116951183/">Neil Turner</a></p>

Goggles
===================

Results are inconclusive. Looking directly at the [init code](https://code.google.com/p/google-api-javascript-client/source/browse/samples/authSample.html) of [google's client api](https://code.google.com/p/google-api-javascript-client/) may result in irreversable eye damage.

Just `promise` me you'll load the api.

Install
-------------

```
bower install --save goggles
```



Usage
-----------

Include this on your page

```html
<script src="path/to/bower/googles"></script>
<script type="text/javascript">
  var goggles = new Goggles({
    apiKey:   "SOME_API_KEY",
    clientId: "SOME_CLKENT_KEY"
    scope: [
      'https://www.googleapis.com/auth/calendar.readonly'
    ]
  });

  // Attach login to button if not automatically logged in
  $("button .google").click(goggles.login)
</script>
```

The `apiKey` allows your app to access public data.   
The `clientId` is the id that the user is authorizing to access their public data.   
The `scope` is a set of permissions that the user is granting to the `clientId`.   


```javascript
// google api promise (goggles)
// returns the `gapi`
goggles.then(function(gapi){

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

*Note* - This _must_ be done syncronously on a button click to prevent the popup from being blocked

Contributing
---------------

Specs please.

License
---------

The MIT License (MIT)

Copyright (c) 2014 Will O'Brien



