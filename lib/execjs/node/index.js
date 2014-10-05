s=require('split')

process.stdin
.pipe(s(cmd))
.pipe(process.stderr)

function cmd(s)
{
  return compile(s)+'\n'
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
