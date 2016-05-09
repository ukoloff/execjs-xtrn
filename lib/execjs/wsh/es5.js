//
// Missing methods for Windows Script Host
//
+function (){

if(!Object.create)
  Object.create = function(proto){
    function fn(){}
    fn.prototype=proto
    return new fn
  }

}()
