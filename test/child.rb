class TestChild < Minitest::Test

  C=ExecJS::Xtrn::Child

  def assert_err(say)
    assert say['err']
  end

  def ch(x)
    n=C.new x
    assert_equal n.say('return 6*7'), {"ok"=>42}
    assert_err n.say false    # Argument error
    assert_err n.say '#'      # Syntax error
    assert_err n.say 'none'   # Runtime error
    assert_equal n.say('return Math.round(Math.PI)'), {'ok'=>3}
  end

  def test_n
    ch C::Node
  end

  def test_w
    ch C::Wsh
  end

end
