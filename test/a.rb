class TestV < Minitest::Test

  C=ExecJS::Xtrn::Child

  def ch(x)
    n=C.new x
    assert_equal '{"a":1,"b":2}', n.say(a:1, b:2)
  end

  def test_n
    ch C::Node
  end

  def test_w
    ch C::Wsh
  end

end
