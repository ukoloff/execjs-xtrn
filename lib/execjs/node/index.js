var s=require('split')

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
  if('string'!=typeof s)
    throw Error('String expected!')
  s = new Function(s)()
  return 'undefined'==typeof s ? {} : {ok: s}
}
