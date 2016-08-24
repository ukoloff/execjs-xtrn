//
// Communicate with cscript via stdin/stderr
//
// For using vm-commands must be run from 32-bit cscript (true if Ruby is 32-bit)
//
+function(){

loadShivs('json2 es5')

function jsText(name)
{
  var
    fso = new ActiveXObject("Scripting.FileSystemObject")
  name = fso.GetParentFolderName(WScript.ScriptFullName)+"/"+name+".js"
  return fso.OpenTextFile(name).ReadAll()
}

function loadShivs(names)
{
  names = names.split(' ')
  for(var i in names)
    new Function(jsText(names[i]))()
}

}()

while(true)
  try {
    +function(result)
    {
      try {
        WScript.StdErr.WriteLine(JSON.stringify(
          'undefined'==typeof result?
          {}
          :
          {ok: result}))
      } catch(e) { throw Error("JSON.stringify error") }
    }(eval(function()
      { // Read line
        var
          w = WScript,
          s = w.StdIn
        if(s.AtEndOfStream)
          w.Quit()
        s = JSON.parse(s.ReadLine())
        if('string' != typeof s)
          throw Error('String expected!')
        return s
      }()))
  } catch (e) { WScript.StdErr.WriteLine(JSON.stringify({err: e.message})) }
