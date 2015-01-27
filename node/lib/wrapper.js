
var parser = require('./coul-parser')

var process = function(ary) {
  var flat = []

  flat = flat.concat.apply(flat, ary)

  flat = flat.filter(function(value, index, ary) {
    return typeof value === 'object'
  })

  obj = {}

  flat.forEach(function(value, index, array) {
    for(var index in value) {
       if (value.hasOwnProperty(index)) {
        obj[index] = value[index]
       }
    }
  })
  console.log(obj)

  return obj;
}

module.exports = function(string) {

  result = parser.parse(string);
  console.log(result)

  return process(result);

}

module.exports.process = process
