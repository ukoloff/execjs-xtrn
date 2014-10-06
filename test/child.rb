class TestChild < Minitest::Test

  Children=[ExecJS::Xtrn::Node, ExecJS::Xtrn::Wsh]

  Chars='Япония, 中华, Russia'
  Codes=[1071, 1087, 1086, 1085, 1080, 1103, 44, 32, 20013, 21326, 44, 32, 82, 117, 115, 115, 105, 97]

  def assert_ok(result, code)
    assert_equal @child.say(code), {'ok'=>result}
  end

  def shag_everything
    assert_ok 42, 'return 6*7'
  end

  def shag_math
    assert_ok 3, 'return Math.round(Math.PI)'
  end

  def shag_intl
    assert_ok Codes, <<-EOJ
      s='#{Chars}'
      r=[]
      for(i=0; i<s.length; i++) r.push(s.charCodeAt(i))
      return r
    EOJ
  end

  def shag_ltni
    assert_ok Chars, <<-EOJ
      c=#{Codes}
      s=''
      for(i=0; i<c.length; i++) s+=String.fromCharCode(c[i])
      return s
    EOJ
  end

  def assert_err(code)
    assert @child.say(code)['err']
  end

  def shag_syntax_error
    assert_err '#'
  end

  def shag_runtime_error
    assert_err 'none'
  end

  def shag_arg_error
    assert_err false
  end

  def children
    Children.map{|k| k::Valid ? ExecJS::Xtrn::Child.new(k::Run) : nil }
  end

  def self.build
    n=0
    instance_methods(false).grep(/^shag_/).each do |m|
      Children.each_index  do |idx|
        define_method("test_#{n+=1}")do
          skip unless @child=(@@children||=children)[idx]
          send m
        end
      end
    end
  end

  build

end
