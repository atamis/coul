var assert = require("assert")
var parser = require('../lib/wrapper')

describe('Wrapper', function() {
  describe('#process', function() {
    var process = parser.process
    it('should ignore non-objects', function() {
      assert.deepEqual({}, process([1, 2, 3, 4, 5]))
      assert.deepEqual({}, process([1, "test", 3, 4, 5]))
    })

    it('should handle empty arrays', function() {
      assert.deepEqual({}, process([]))
    })

    it("should aggregate tags", function() {
      assert.deepEqual({"test":4}, process([4, 6, 3, 7, {"test":4}]))
      assert.deepEqual({"test":4, "awesome": 15},
                       process([4, {"awesome": 15}, 3, 7, {"test":4}]))
    })

    it("should handle nested arrasy", function() {
      assert.deepEqual({"test":4, "awesome": 15},
                       process([4, [{"awesome": 15}], 3, 7, {"test":4}]))
    })
  })

})


describe('Parser', function(){
  describe('#ping', function(){
    it('should parse pings', function() {
      assert.equal("PING", parser("COUL 0.1.0 PING\n\n").command)
    })
  })

  describe('#pong', function(){
    it('should parse pongs', function() {
      assert.equal("PONG", parser("COUL 0.1.0 PONG\n\n").command)
    })
  })

  describe('#msg', function(){
    it('should parse msg', function() {
      var obj = parser("COUL 0.1.0 MSG bots\nThis is a test\n\n")
      assert.equal("MSG", obj.command)
      assert.equal("bots", obj.channel)
      assert.equal("This is a test\n", obj.message)
    })
    it('should parse multi-line msg', function() {
      var obj = parser("COUL 0.1.0 MSG bots\nThis is a test\nNice.\n\n")
      assert.equal("MSG", obj.command)
      assert.equal("bots", obj.channel)
      assert.equal("This is a test\nNice.\n", obj.message)
    })
  })

  describe('#smsg', function(){
    it('should parse hostname smsg', function() {
      var obj = parser("COUL 0.1.0 SMSG indigo@test.com bots 542.523\nThis is a test.\nNice.\n\n")
      assert.equal("SMSG", obj.command)
      assert.equal("bots", obj.channel)
      assert.equal("indigo", obj.nick)
      assert.equal("test.com", obj.server)
      assert.equal("542.523", obj.timestamp)
      assert.equal("This is a test.\nNice.\n", obj.message)
    })

    it('should parse longer hostname smsg', function() {
      var obj = parser("COUL 0.1.0 SMSG indigo@mail.test.com bots 542.523\nThis is a test.\nNice.\n\n")
      assert.equal("SMSG", obj.command)
      assert.equal("bots", obj.channel)
      assert.equal("indigo", obj.nick)
      assert.equal("mail.test.com", obj.server)
      assert.equal("542.523", obj.timestamp)
      assert.equal("This is a test.\nNice.\n", obj.message)
    })

    it('should parse ip smsg', function() {
      var obj = parser("COUL 0.1.0 SMSG indigo@192.168.1.244 bots 542.523\nThis is a test.\nNice.\n\n")
      assert.equal("SMSG", obj.command)
      assert.equal("bots", obj.channel)
      assert.equal("indigo", obj.nick)
      assert.equal("192.168.1.244", obj.server)
      assert.equal("542.523", obj.timestamp)
      assert.equal("This is a test.\nNice.\n", obj.message)
    })
    it('should parse ip addresses', function() {
      for(var one = 0; one < 256; one++) {
        var ip = one.toString() + ".162.1.143"
        var obj = parser("COUL 0.1.0 SMSG indigo@" + ip + " bots 542.523\nThis is a test.\nNice.\n\n")
        assert.equal(ip, obj.server)
      }
    })
  })

  describe("#alert", function() {
    it('should parse server alert messages', function() {
      var obj = parser("COUL 0.1.0 ALERT SERVER 4235.42\nThis is an alert.\nNo further information.\n\n")
      assert.equal("SERVER", obj.source)
      assert.equal("4235.42", obj.timestamp)
      assert.equal("This is an alert.\nNo further information.\n", obj.message)
    })

    it('should parse network alert messages', function() {
      var obj = parser("COUL 0.1.0 ALERT NETWORK 4235.42\nThis is an alert.\nNo further information.\n\n")
      assert.equal("NETWORK", obj.source)
      assert.equal("4235.42", obj.timestamp)
      assert.equal("This is an alert.\nNo further information.\n", obj.message)
    })
  })


})

