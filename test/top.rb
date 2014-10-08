class TestTop < Minitest::Test

  def test_exec
    assert_equal 42, ExecJS.exec('return 6*7')
  end

  def test_eval
    assert_equal 42, ExecJS.eval('6*7')
  end

  def test_compile
    ctx=ExecJS.compile <<-EOJ
      dec = function(i)
      {
        return i-1
      }
    EOJ
    assert_equal 8, ctx.call('dec', 9)
  end

end
