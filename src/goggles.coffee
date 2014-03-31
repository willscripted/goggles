Q = require('q')

do (window, document) ->

  WINDOW_CALLBACK_NAME = 'gogglesOnLoad'

  class Goggles

    constructor: (opts = {}) ->
      throw "api key required" unless opts.apiKey
      throw "client id required" unless opts.clientId

      @def = Q.defer()

      @apiKey = opts.apiKey
      @clientId = opts.clientId
      @scopes = opts.scope || []

      window[WINDOW_CALLBACK_NAME] = @windowCallback

      @appendGapiScript()
      @def.promise.login = @login

      return @def.promise

    windowCallback: =>
      @gapi = window.gapi
      @gapi.client.setApiKey(@apiKey)
      @gapi.auth.authorize({client_id: @clientId, scope: @scopes, immediate: true}, @handleAuthResult)

    appendGapiScript: ->
      tag = document.createElement('script')
      tag.type = 'text/javascript'
      tag.async = true
      tag.src = "https://apis.google.com/js/client.js?onload=#{WINDOW_CALLBACK_NAME}"

      sib = document.getElementsByTagName('script')[0]
      sib.parentNode.insertBefore(tag, sib)

    login: =>
      @gapi.auth.authorize({client_id: @clientId, scope: @scopes, immediate: false}, @handleAuthResult)

    handleAuthResult: (authResult) =>
      if authResult
        if authResult.error
          @def.reject(authResult)
        else
          @def.resolve(@gapi)

  window.Goggles = Goggles

