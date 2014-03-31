
jsdom = require("jsdom")

getMockGapi = () ->
  return @gapi or @gapi =
    auth:
      authorize: ->
    client:
      setApiKey: ->

getMockSibling = (window) ->
  sib =
    parentNode:
      insertBefore: (newT, existingT) =>
        if existingT == sib

          match = /^https:\/\/apis\.google\.com\/js\/client\.js\?onload=([a-zA-Z0-9]+)$/.exec(newT.src)

          return unless match and match[1]

          window.gapi = getMockGapi.call(this, window)
          window[match[1]]()

stubSibling = (window) ->
  mockSibling = getMockSibling.call(this, window)

  sinon.stub(window.document, "getElementsByTagName")
    .withArgs('script')
    .returns([mockSibling])

describe "Goggles", ->

  beforeEach (done) ->
    # Build our fake dom
    jsdom.env("<head></head>",
      ['../../build/goggles.main.js']
      , (errors, window) =>
        @window = window
        stubSibling.call(this, window)
        getMockGapi.call(this)
        done()
    )

  afterEach ->
    @window.close()

  describe "#constructor", ->

    it "loads the gapi", (done) ->
      spy = sinon.spy(@window.Goggles::, "windowCallback")
      g = new @window.Goggles({
        apiKey: "apiKeyzzz",
        clientId: "identz",
        scope: []
      })
      expect(spy.called).to.be.true
      spy.restore()
      done()


    it "sets the api key", (done) ->
      apiKey = "apiKeyzzz"
      spy = sinon.spy(@gapi.client, "setApiKey")
      g = new @window.Goggles({
        apiKey: apiKey,
        clientId: "identz",
        scope: []
      })
      expect(spy.calledWith(apiKey)).to.be.true
      spy.restore()
      done()

    it "attempts a silent authectication", ->
      spy = sinon.spy(@gapi.auth, "authorize")

      g = new @window.Goggles({
        apiKey: "some-apiKey",
        clientId: (clientId = "some-client-id"),
        scope: [(scope = "some-scope")]
      })

      expect(spy.calledOnce).to.be.true

      args = spy.firstCall.args

      # verify callback
      expect(args[1]).to.be.a('function')

      # verify options
      options = args[0]
      expect(options.client_id).to.equal(clientId)
      expect(options.scope).to.include(scope)
      expect(options.immediate).to.be.true
      spy.restore()

  describe "#then", ->
    stubAuth = (immediate, sync) ->
      return (opts, cb) ->
        if opts.immediate
          cb(immediate)
        else
          cb(sync)

    context "when silent auth is successful", ->
      beforeEach ->
        @stub = sinon.stub(@gapi.auth, "authorize", stubAuth({}, {}))
      afterEach ->
        @stub.restore()

      it "resolves", (done) ->
        spy = sinon.spy()
        @g = new @window.Goggles({
          apiKey: "some-apiKey",
          clientId: "some-client-id",
          scope: ["some-scope"]
        }).then(spy)
        setTimeout( =>
          expect(spy.calledOnce).to.be.true
          expect(spy.firstCall.args[0]).to.equal(@gapi)
          done()
        , 4)

    context "when silent auth is null", ->
      beforeEach ->
        @stub = sinon.stub(@gapi.auth, "authorize", stubAuth(null, {}))
      afterEach ->
        @stub.restore()

      it "does not resolve", (done) ->
        spy = sinon.spy()
        @g = new @window.Goggles({
          apiKey: "some-apiKey",
          clientId: (@clientId = "some-client-id"),
          scope: [(@scope = "some-scope")]
        })
        .then(spy)
        setTimeout( =>
          expect(spy.called).to.be.false
          expect(@g)
          done()
        , 4)

    context "when silent auth errors", ->
      beforeEach ->
        @stub = sinon.stub(@gapi.auth, "authorize", stubAuth({error: "uh oh"}, {}))

      afterEach ->
        @stub.restore()

      it "rejects", (done) ->
        calledSpy = sinon.spy()
        notCalledSpy = sinon.spy()
        @g = new @window.Goggles({
          apiKey: "some-apiKey",
          clientId: "some-client-id",
          scope: ["some-scope"]
        })
        .then(notCalledSpy, calledSpy)
        .fin( =>
          expect(   calledSpy.called).to.be.true
          expect(notCalledSpy.called).to.be.false
          done()
        )

    context "when manual auth is successful", ->
      beforeEach ->
        @stub = sinon.stub(@gapi.auth, "authorize", stubAuth(null, {}))

      afterEach ->
        @stub.restore()

      it "resolves", (done) ->
        spy = sinon.spy()
        @g = new @window.Goggles({
          apiKey: "some-apiKey",
          clientId: "some-client-id",
          scope: ["some-scope"]
        })
        @g.then(spy)
        .fin( =>
          expect(spy.called).to.be.true
          done()
        )
        @g.login()

    context "when manual auth fails", ->
      beforeEach ->
        @stub = sinon.stub(@gapi.auth, "authorize", stubAuth(null, {error: "oh no"}))

      afterEach ->
        @stub.restore()

      it "errors", (done) ->
        spyCalled    = sinon.spy()
        spyNotCalled = sinon.spy()

        @g = new @window.Goggles({
          apiKey: "some-apiKey",
          clientId: "some-client-id",
          scope: ["some-scope"]
        })
        @g.then(spyNotCalled, spyCalled)
        .fin( =>
          expect(   spyCalled.called).to.be.true
          expect(spyNotCalled.called).to.be.false
          done()
        )
        @g.login()

  describe "#login", ->
    beforeEach ->
      stub = sinon.stub(@gapi.auth, "authorize", (opts, cb) ->
        unless opts.immediate
          cb(null)
      )

      @g = new @window.Goggles({
        apiKey: "some-apiKey",
        clientId: (@clientId = "some-client-id"),
        scope: [(@scope = "some-scope")]
      })
      stub.restore()

    it "performs a synchronous login", ->
      spy = sinon.spy(@gapi.auth, "authorize")
      @g.login()

      expect(spy.calledOnce).to.be.true

      args = spy.firstCall.args

      # verify callback
      expect(args[1]).to.be.a('function')

      # verify options
      options = args[0]
      expect(options.client_id).to.equal(@clientId)
      expect(options.scope).to.include(@scope)
      expect(options.immediate).to.be.false
      spy.restore()

