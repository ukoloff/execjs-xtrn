class TestChild < Minitest::Test

  M=ExecJS::Xtrn

  Spawn=2
  Children=[M::Node, M::Wsh]

  Chars='Япония, 中华, Russia'
  Codes=[1071, 1087, 1086, 1085, 1080, 1103, 44, 32, 20013, 21326, 44, 32, 82, 117, 115, 115, 105, 97]

  def say(code)
    @child.say code
  end

  def assert_ok(result, code)
    r=say code
    refute r.key? 'err'
    assert_equal r, {'ok'=>result}
  end

  def shag_math
    assert_ok 42, 'return 6*7'
    assert_ok 3, 'return Math.round(Math.PI)'
  end

  def shag_intl
    assert_ok Codes, <<-EOJ
      s='#{Chars}'
      r=[]
      for(i=0; i<s.length; i++) r.push(s.charCodeAt(i))
      return r
    EOJ

    assert_ok Chars, <<-EOJ
      c=#{Codes}
      s=''
      for(i=0; i<c.length; i++) s+=String.fromCharCode(c[i])
      return s
    EOJ
  end

  def assert_err(code)
    assert say(code)['err']
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

    v=rand 1000
    assert_err 'globalVar'
    say "globalVar=#{v}"
    assert_ok v, 'return globalVar'
  end

  def children
    (1..Spawn).map do
      Children.map{|k| k::Valid ? M::Child.new(k::Run) : nil }
    end
  end

  def self.build
    instance_methods(false).grep(/^shag_/).each do |m|
      Children.each_with_index  do |klass, idx|
        (1..Spawn).each do |n|
          define_method("test_#{m.to_s.sub /.*?_/, ''}_#{klass.name.split(/\W+/).last}_#{n}")do
            skip unless @child=(@@children||=children)[n-1][idx]
            send m
          end
        end
      end
    end
  end

  build

end
