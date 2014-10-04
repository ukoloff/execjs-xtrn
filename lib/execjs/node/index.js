s=require('split')

process.stdin
.pipe(s(cmd))
.pipe(process.stderr)

function cmd(s)
{
  return JSON.stringify(s)+'\n'
}
