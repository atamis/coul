var assert = require("assert")
var parser = require('../lib/wrapper')

describe('Array', function(){
  describe('#indexOf()', function(){
    it('should return -1 when the value is not present', function(){
      assert.equal(-1, [1,2,3].indexOf(5));
      assert.equal(-1, [1,2,3].indexOf(0));
    })
  })
})

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

})

