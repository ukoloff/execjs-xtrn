s=require('split')

process.stdin
.pipe(s(function(s){return JSON.stringify(s)+'\n'}))
.pipe(process.stderr)
