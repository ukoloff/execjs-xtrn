# encoding: utf-8
class Shagi < Minitest::Test

  Spawn=5
  M=ExecJS::Xtrn

  def say(code)
    raise NotImplementedError, self.class.name
  end

  def assert_ok(result, code)
    r=say code
    refute r.key? 'err'
    assert_equal r, {'ok'=>result}
  end

  def assert_err(code)
    assert say(code)['err']
  end

  def shag_math
    assert_ok 42, 'return 6*7'
    assert_ok 3,  'return Math.round(Math.PI)'
  end

  Chars='Япония, 中华, Russia'
  Codes=[1071, 1087, 1086, 1085, 1080, 1103, 44, 32, 20013, 21326, 44, 32, 82, 117, 115, 115, 105, 97]

  def shag_intl
    assert_ok Codes, <<-EOJ
      var s='#{Chars}'
      var r=[]
      for(var i=0; i<s.length; i++) r.push(s.charCodeAt(i))
      return r
    EOJ

    assert_ok Chars, <<-EOJ
      var c=#{Codes}
      var s=''
      for(var i=0; i<c.length; i++) s+=String.fromCharCode(c[i])
      return s
    EOJ
  end

  def shag_error
    assert_err '#'      # Syntax
    assert_err 'none'   # Runtime
    assert_err false    # Argument
    assert_err key: 2   # the same
  end

  def shag_null
    assert_equal say(''), {}
    assert_ok nil, 'return null'
  end

  def shag_vars
    assert_err 'localVar'
    say 'var localVar=1'
    assert_err 'localVar'

    assert_err 'globalVar'
    say "globalVar=#{v=rand 1000}"
    assert_ok v, 'return globalVar'
  end

  def shag_stats
    @child.stats r={}
    say '//'
    assert_equal r[:n], 1
    ri=@child.stats
    rc=@child.class.stats
    say ''
    assert_equal r[:n], 2
    assert_equal ri[:n]+1, @child.stats[:n]
    assert_equal rc[:n]+1, @child.class.stats[:n]
    [r, ri, rc].each{|rec| %w(i o t).each{|sym| assert rec[sym.to_sym]}}
    assert_operator rc[:c], :>, 0
  end

  def shag_es5
    assert_ok 7, 'return Object.create({a: 7}).a'
    assert_ok ['one', 'two'], 'return Object.keys({one: 1, two: 2})'
    assert_ok 2, 'return [5, 6, 7, 8].indexOf(7)'
    assert_ok -1, 'return [5, 6, 7, 8].indexOf(3)'
    assert_ok [1,3], 'return [1, 2, 3, 4].filter(function(n){return n&1})'
    assert_ok 'pqr', <<-EOJ
      var s=''
      'p q r'.split(' ').forEach(function(n){s+=n})
      return s
    EOJ
  end

end
