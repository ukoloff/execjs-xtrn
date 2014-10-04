var i=WScript.StdIn

while(!i.AtEndOfStream)
  WScript.StdOut.WriteLine('<<'+i.ReadLine()+'>>')
