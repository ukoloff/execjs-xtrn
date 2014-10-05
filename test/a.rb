class TestV < Minitest::Test

  C=ExecJS::Xtrn::Child

  def ch(x)
    n=C.new x
    assert_equal n.say('return 6*7'), {"ok"=>42}
  end

  def test_n
    ch C::Node
  end

  def test_w
    ch C::Wsh
  end

end
