//
// Missing methods for Windows Script Host
//
+function (){

if(!Object.create)
Object.create = function(proto) {
  function fn() {}
  fn.prototype = proto
  return new fn
}

if(!Object.keys)
Object.keys = function(obj) {
  var results = []
  for (var k in obj)
    results.push(k)
  return results
}

var base = Array.prototype
if(!base.indexOf)
base.indexOf = function(el) {
  for (var i = this.length - 1; i >= 0; i--)
    if (el === this[i])
      return i
  return -1
}

if(!base.forEach)
base.forEach = function(fn) {
  for (var i = 0, len = this.length; i < len; i++)
    fn(this[i], i, this)
}

if(!base.filter)
base.filter = function(fn) {
  var z, results = []
  for (var i = 0, len = this.length; i < len; i++)
    if (fn(z = this[i], i, this))
      results.push(z)
  return results
}

}()
