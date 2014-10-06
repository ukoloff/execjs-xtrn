class TestEngine < Minitest::Test

  @@x=ExecJS::Xtrn::Wsh.new

  def test_exec
    assert_equal 42, @@x.exec('return 6*7')
  end

  def test_eval
    x=ExecJS::Xtrn::Wsh.new
    assert_equal 42, @@x.eval('6*7')
  end

  def test_call
    assert_equal 79, @@x.call('Math.max', 44, 27, 79, 73, 42, 4, 23, 24, 36, 13)
  end

end
