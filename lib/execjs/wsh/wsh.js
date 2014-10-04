var
  w = WScript,
  i = w.StdIn,
  o = w.StdOut

readJ2()

while(!i.AtEndOfStream)
  o.WriteLine(JSON.stringify(i.ReadLine()))

function readJ2()
{
  var
    fso = new ActiveXObject("Scripting.FileSystemObject"),
    j2 = fso.GetParentFolderName(w.ScriptFullName)+"/json2.js"
  new Function(fso.OpenTextFile(j2).ReadAll())()
}
