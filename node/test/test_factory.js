var factory = require('../lib/factory')
var parser = require('../lib/wrapper')
var assert = require('assert')
var version = require('../lib/version')

describe("factory", function() {
  describe("#ping", function() {
    it('should build a ping message', function() {
      assert.equal("COUL " + version + " PING\n\n", factory.ping())
    })
    it('should build a parsable ping message', function(){
      var obj = parser(factory.ping())
      assert.deepEqual({"command":"PING"}, obj)
    })
  })

  describe("#pong", function() {
    it('should build a pong message', function() {
      assert.equal("COUL " + version + " PONG\n\n", factory.pong())
    })
    it('should build a parsable pong message', function(){
      var obj = parser(factory.pong())
      assert.deepEqual({"command":"PONG"}, obj)
    })
  })

  describe("#smsg", function() {
    it('should build an smsg message', function() {
      assert.equal("COUL " + version + " SMSG indigo@test.awesome.com bots 43287.453\nThis is a test.\nNice.\n\n",
                  factory.smsg("indigo", "test.awesome.com", "bots", 43287.453, "This is a test.\nNice.\n"))
      assert.equal("COUL " + version + " SMSG indigo@test.awesome.com bots 43287.453\nThis is a test.\nNice.\n\n",
                  factory.smsg("indigo", "test.awesome.com", "bots", "43287.453", "This is a test.\nNice.\n"))
    })
    it('should deal with messages without newlines', function() {
      assert.equal("COUL " + version + " SMSG indigo@test.awesome.com bots 43287.453\nThis is a test.\n\n",
                  factory.smsg("indigo", "test.awesome.com", "bots", "43287.453", "This is a test."))
    })
    it('should build a parsable smsg message', function() {
      var obj = parser(factory.smsg("indigo", "test.awesome.com", "bots", "12345.12345", "This is a test.\nNice.\n"))
      assert.deepEqual({"command": "SMSG",
                        "nick": "indigo",
                        "server": "test.awesome.com",
                        "channel": "bots",
                        "timestamp": "12345.12345",
                        "message": "This is a test.\nNice.\n"
      }, obj)
    })
  })

  describe("#msg", function() {
    it("should build a msg message", function() {
      assert.equal("COUL " + version + " MSG bots\nThis is a test.\nNice.\n\n", factory.msg("bots", "This is a test.\nNice.\n"))
      assert.equal("COUL " + version + " MSG bots\nThis is a test.\n\n", factory.msg("bots", "This is a test.\n"))
    })

    it("should add a newline to messages", function() {
      assert.equal("COUL " + version + " MSG bots\nThis is a test.\n\n", factory.msg("bots", "This is a test."))
    })

    it("should produce parsable msg messages", function() {
      var obj = parser(factory.msg("bots", "This is a test\n"))
      assert.deepEqual({"command":"MSG",
                       "channel":"bots",
                       "message":"This is a test\n"
      }, obj)
    })
  })
})
