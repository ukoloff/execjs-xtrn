//
// Communicate with cscript via stdin/stderr
//
// For using vm-commands must be run from 32-bit cscript (true if Ruby is 32-bit)
//
+function(){

var
  w = WScript,
  i = w.StdIn,
  o = w.StdErr,
  vms = {},
  lastShim

loadShivs('json2 es5')

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
  if('object' != typeof s)
    throw Error('Hash expected!')
  if(!('vm' in s))
    throw Error('VM command expected!')
  if('js' in s)
    return vmEval(s)
  if(!s.vm)
    return {vm: vmNew()}
  delete vms[s.vm]
  return {}
}

function ok(v)
{
  return 'undefined'==typeof v ? {} : {ok: v}
}

function jsText(name)
{
  var
    fso = new ActiveXObject("Scripting.FileSystemObject")
  name = fso.GetParentFolderName(w.ScriptFullName)+"/"+name+".js"
  return fso.OpenTextFile(name).ReadAll()
}

function loadShivs(names)
{
  names = names.split(' ')
  for(var i in names)
    new Function(lastShim = jsText(names[i]))()
}

function vmNew()
{
  var i, r
  for(i = 10; i>0; i--)
    if((r = /\d{3,}/.exec(Math.random())) && !vms[r = r[0]])
    {
      vms[r] = i = new ActiveXObject('ScriptControl')
      i.Language = 'JScript'
      i.addCode(lastShim)
      return r
    }
  throw Error('Cannot generate random number')
}

function vmEval(s)
{
  var z = vms[s.vm]
  if(!z)
    throw Error('VM not found')
  if('string'!=typeof s.js)
    throw Error('String expected!')
  return ok(z.eval(s.js))
}

}()
