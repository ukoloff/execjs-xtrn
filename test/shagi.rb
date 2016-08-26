# encoding: utf-8
class Shagi < Minitest::Test

  Spawn=5
  M=ExecJS::Xtrn

  def say(code)
    raise NotImplementedError, self.class.name
  end

  def treba_ok(result, code)
    r=say code
    refute r.key? 'err'
    assert_equal r, {'ok'=>result}
  end

  def treba_err(code)
    assert say(code)['err']
  end

  def self.shagi
    ancestors[1].instance_methods(false).grep(/^shag_/).map do |m|
      [m, m.to_s.sub(/.*?_/, '')]
    end
  end

  def shag_math
    treba_ok 42, '6*7'
    treba_ok 3,  'Math.round(Math.PI)'
  end

  Chars='Япония, 中华, Russia'
  Codes=[1071, 1087, 1086, 1085, 1080, 1103, 44, 32, 20013, 21326, 44, 32, 82, 117, 115, 115, 105, 97]

  def shag_intl
    treba_ok Codes, <<-EOJ
      var s='#{Chars}'
      var r=[]
      for(var i=0; i<s.length; i++) r.push(s.charCodeAt(i))
      r
    EOJ

    treba_ok Chars, <<-EOJ
      String.fromCharCode(#{Codes * ', '})
    EOJ
  end

  def shag_error
    treba_err '#'      # Syntax
    treba_err 'none'   # Runtime
    treba_err false    # Argument
    treba_err key: 2   # the same
  end

  def shag_null
    assert_equal say(''), {}
    treba_ok nil, 'null'
  end

  def shag_vars
    treba_err 'localVar'
    say "var localVar=#{v=rand 1000}"
    treba_ok v, 'localVar'

    treba_err 'globalVar'
    say "globalVar=#{v=rand 1000}"
    treba_ok v, 'globalVar'
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
    treba_ok 7, 'Object.create({a: 7}).a'
    treba_ok ['one', 'two'], 'Object.keys({one: 1, two: 2})'
    treba_ok true, 'Array.isArray([3, 14, 159])'
    treba_ok false, 'Array.isArray(27)'
    treba_ok 2, '[5, 6, 7, 8].indexOf(7)'
    treba_ok -1, '[5, 6, 7, 8].indexOf(3)'
    treba_ok [1,3], '[1, 2, 3, 4].filter(function(n){return n&1})'
    treba_ok 'pqr', <<-EOJ
      var s=''
      'p q r'.split(' ').forEach(function(n){s+=n})
      s
    EOJ
  end

end
