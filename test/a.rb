class TestV < Minitest::Test

  C=ExecJS::Xtrn::Child

  def test_n
    n=C.new C::Node
    assert_equal '{"a":1,"b":2}', n.say(a:1, b:2)
  end

  def test_w
    n=C.new C::Wsh
    assert_equal '{"a":1,"b":2}', n.say(a:1, b:2)
  end

end
