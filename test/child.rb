class TestChild < Minitest::Test

  Chars='Япония, 中文, Russia'
  Codes=[1071, 1087, 1086, 1085, 1080, 1103, 44, 32, 20013, 25991, 44, 32, 82, 117, 115, 115, 105, 97]

  def assert_err(say)
    assert say['err']
  end

  def ch(klass)
    skip unless klass::Valid
    n=ExecJS::Xtrn::Child.new klass::Run
    assert_equal n.say('return 6*7'), {"ok"=>42}
    assert_err n.say false    # Argument error
    assert_equal n.say('return Math.round(Math.PI)'), {'ok'=>3}
    assert_equal n.say(<<EOJ), {"ok"=>Codes}
s='#{Chars}'
r=[]
for(i=0; i<s.length; i++) r.push(s.charCodeAt(i))
return r
EOJ
    assert_err n.say '#'      # Syntax error
    assert_equal n.say(<<EOJ), {"ok"=>Chars}
c=#{Codes}
s=''
for(i=0; i<c.length; i++) s+=String.fromCharCode(c[i])
return s
EOJ
    assert_err n.say 'none'   # Runtime error

  end

  def test_n
    ch ExecJS::Xtrn::Node
  end

  def test_w
    ch ExecJS::Xtrn::Wsh
  end

end
