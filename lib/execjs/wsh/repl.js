!function(){

var
  w = WScript,
  i = w.StdIn,
  o = w.StdErr

!function()
{
  var
    fso = new ActiveXObject("Scripting.FileSystemObject"),
    j2 = fso.GetParentFolderName(w.ScriptFullName)+"/json2.js"
  new Function(fso.OpenTextFile(j2).ReadAll())()
}()

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
  s = new Function(s)()
  return 'undefined'==typeof s ? {} : {ok: s}
}

}()
