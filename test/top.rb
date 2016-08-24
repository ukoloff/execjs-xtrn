require 'coffee-script'
require 'uglifier'

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
    ctx=ExecJS.compile <<-EOJ
      summa = function(n)
      {
        var r=0
        for(var i = 1; i<=n; i++)
        {
          r+=i
          for(var t = ms() ; t>=ms(); );
        }
        return r
      }
      function ms()
      {
        return new Date().getTime()
      }
    EOJ
    s=ctx.stats
    %w(i o n t).each{|sym| assert s[sym.to_sym]}
    ctx.exec ' '
    assert_equal s, ctx.stats
    assert_equal 5050, ctx.call('summa', 100)
    assert_equal s[:n]+1, ctx.stats[:n]
    %w(i o t).each{|sym| assert_operator s[sym.to_sym], :<, ctx.stats[sym.to_sym]}
  end

  def test_coffee
    assert CoffeeScript.compile('->', header: true)[CoffeeScript.version]
    assert CoffeeScript.compile('a b c', bare: true)['a(b(c))']
  end

  def test_uglify
    u=Uglifier.new
    assert u.compile('a( 1 + 2 * 3 )')['a(7)']
    assert u.compile('b( 1 ? x : y )')['b(x)']
  end

  def test_switch
    assert_equal 42, ExecJS.eval('7*6')
    e=ExecJS::Xtrn.engine
    ExecJS::Xtrn.engine=FakeEngine
    assert_equal 1, ExecJS.exec('A')
    assert_equal 2, ExecJS.eval('B')
    assert_equal 4, ExecJS.compile.eval('C')
    ExecJS::Xtrn.engine=e
    assert_equal 42, ExecJS.eval('21*2')
  end

  def test_info
    at_exit do
      puts "Statistics:"
      s=ExecJS::Xtrn.stats
      len=s.keys.map(&:length).max+1
      z = s.map do |k, v|
        "#{' '*(len-k.length)}#{k}: "+
        v.map do |kx, vx|
          "#{kx}=#{vx.round(3).to_s.sub(/[.]?0*$/, '')}"
        end * ', '
      end * "\n"
      puts z
      AppVeyor::Worker.message "Compilations: #{s['Engine'][:n]}", z
    end
  end

end

class FakeEngine < ExecJS::Xtrn::Engine
  def eval(s='')
    @@n||=0
    @@n+=1
  end
end
