!function(){

var
  w = WScript,
  i = w.StdIn,
  o = w.StdErr

json2()
oCreate()

while(!i.AtEndOfStream)
  o.WriteLine(wrap(i.ReadLine()))

function wrap(s)
{
  try { s=compile(s) }
  catch(e) { s={err: e.message || 'General error'} }

  try { return JSON.stringify(s) }
  catch(e) { return '{"err":"JSON.stringify error"}' }
}

function compile(s)
{
  s = JSON.parse(s)
  if('string'!=typeof s)
    throw Error('String expected!')
  return ok(new Function(s)())
}

function ok(v)
{
  return 'undefined'==typeof v ? {} : {ok: v}
}

// Load JSON2
function json2()
{
  var
    fso = new ActiveXObject("Scripting.FileSystemObject"),
    j2 = fso.GetParentFolderName(w.ScriptFullName)+"/json2.js"
  new Function(fso.OpenTextFile(j2).ReadAll())()
}

// Fix for CoffeeScript 1.9+
function oCreate()
{
  if(Object.create) return
  Object.create=function(proto)
  {
    f=function(){}
    f.prototype=proto
    return new f
  }
}

}()
