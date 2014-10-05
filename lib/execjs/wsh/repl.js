!function(){

var
  w = WScript,
  i = w.StdIn,
  o = w.StdErr

readJ2()

while(!i.AtEndOfStream)
  o.WriteLine(compile(i.ReadLine()))

function readJ2()
{
  var
    fso = new ActiveXObject("Scripting.FileSystemObject"),
    j2 = fso.GetParentFolderName(w.ScriptFullName)+"/json2.js"
  new Function(fso.OpenTextFile(j2).ReadAll())()
}

function compile(s)
{
  try{
    s = JSON.parse(s)
    if('string'!=typeof s)
      throw Error('String expected!')
    s = new Function(s)()
    return JSON.stringify('undefined'==typeof s ? {} : {ok: s})
  }
  catch(e){
    try{
      return JSON.stringify({err: e.message})
    }
    catch(e){
      return '{"err":"Double error"}'
    }
  }
}

}()
