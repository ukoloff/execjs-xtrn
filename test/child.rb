class TestChild < Minitest::Test

  def assert_err(say)
    assert say['err']
  end

  def ch(klass)
    skip unless klass::Valid
    n=ExecJS::Xtrn::Child.new klass::Run
    assert_equal n.say('return 6*7'), {"ok"=>42}
    assert_err n.say false    # Argument error
    assert_err n.say '#'      # Syntax error
    assert_err n.say 'none'   # Runtime error
    assert_equal n.say('return Math.round(Math.PI)'), {'ok'=>3}
  end

  def test_n
    ch ExecJS::Xtrn::Node
  end

  def test_w
    ch ExecJS::Xtrn::Wsh
  end

end
