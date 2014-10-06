class TestChild < Minitest::Test

  Children=[ExecJS::Xtrn::Node, ExecJS::Xtrn::Wsh]

  Chars='Япония, 中华, Russia'
  Codes=[1071, 1087, 1086, 1085, 1080, 1103, 44, 32, 20013, 21326, 44, 32, 82, 117, 115, 115, 105, 97]

  def assert_ok(child, result, code)
    assert_equal child.say(code), {'ok'=>result}
  end

  def shag_everything(z)
    assert_ok z, 42, 'return 6*7'
  end

  def shag_math(z)
    assert_ok z, 3, 'return Math.round(Math.PI)'
  end

  def shag_intl(z)
    assert_ok z, Codes, <<-EOJ
      s='#{Chars}'
      r=[]
      for(i=0; i<s.length; i++) r.push(s.charCodeAt(i))
      return r
    EOJ
  end

  def shag_ltni(z)
    assert_ok z, Chars, <<-EOJ
      c=#{Codes}
      s=''
      for(i=0; i<c.length; i++) s+=String.fromCharCode(c[i])
      return s
    EOJ
  end

  def assert_err(say)
    assert say['err']
  end

  def shag_syntax_error(z)
    assert_err z.say '#'
  end

  def shag_runtime_error(z)
    assert_err z.say 'none'
  end

  def shag_arg_error(z)
    assert_err z.say false
  end

  def self.build
    n=0
    instance_methods(false).grep(/^shag_/).each do |m|
      Children.each_index  do |idx|
        define_method("test_#{n+=1}")do
          child=@@children[idx]
          skip unless child
          send m, child
        end
      end
    end
    @@children=[ExecJS::Xtrn::Node, ExecJS::Xtrn::Wsh].map do |klass|
      klass::Valid ? ExecJS::Xtrn::Child.new(klass::Run) : nil
    end
  end

  build

end
