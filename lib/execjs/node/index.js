var
  s=require('split'),
  vm = require('vm'),
  vms = {}

process.stdin
.pipe(s(cmd))
.pipe(process.stderr)

function cmd(s)
{
  return wrap(s)+'\n'
}

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
  if('object'==typeof s)
    return vmCmd(s)
  if('string'!=typeof s)
    throw Error('String expected!')
  return ok(new Function(s)())
}

function ok(v)
{
  return 'undefined'==typeof v ? {} : {ok: v}
}

function vmCmd(s)
{
  if(!('vm' in s))
    throw Error('VM command expected!')
  if('js' in s)
    return vmEval(s)
  if(!s.vm)
    return {vm: vmNew()}
  delete vms[s.vm]
  return {}
}

function vmEval(s)
{
  var z = vms[s.vm]
  if(!z)
    throw Error('VM not found')
  if('string'!=typeof s.js)
    throw Error('String expected!')
  return ok(vm.runInContext('new Function('+JSON.stringify(s.js)+')()', z))
}

function vmNew()
{
  var i, r
  for(i = 10; i>0; i--)
    if((r = /\d{3,}/.exec(Math.random())) && !vms[r = r[0]])
    {
      vms[r] = vm.createContext()
      return r
    }
  throw Error('Cannot generate random number')
}
