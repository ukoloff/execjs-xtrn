require 'coffee-script'
ExecJS::Xtrn.init

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

  def test_stats
    ExecJS.exec '//'
    s=ExecJS.stats
    %w(c i o t).each{|sym| assert s[sym.to_sym]}
    ExecJS.exec ' '
    assert_equal s[:n], ExecJS.stats[:n]
    ExecJS.exec 'null'
    assert_operator s[:n], :<, ExecJS.stats[:n]
  end

  def test_coffee
    assert CoffeeScript.compile('->', header: true)[CoffeeScript.version]
    assert CoffeeScript.compile('a b c', bare: true)['a(b(c))']
  end

end
