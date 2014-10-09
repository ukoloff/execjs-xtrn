require 'coffee_script/source'

class TestEngine < Minitest::Test

  M=ExecJS::Xtrn

  Spawn=2
  Engines=[M::Node, M::Wsh]

  def shag_methods
    refute @engine.exec <<-EOJ
      fib = function(n)
      {
        return n<2 ? 1 : fib(n-1)+fib(n-2)
      }
    EOJ
    assert_equal 89, @engine.eval('fib(10)')
    assert_equal 8,  @engine.call('fib', 5)
    assert_equal 79, @engine.call('Math.max', 44, 27, 79, 73, 42, 4, 23, 24, 36, 13)
  end

  def shag_vars
    assert_raises(RuntimeError){ @engine.eval 'localVar' }
    refute @engine.exec 'var localVar=1'
    assert_raises(RuntimeError){ @engine.eval 'localVar' }

    assert_raises(RuntimeError){ @engine.eval 'globalVar' }
    refute @engine.exec "globalVar=#{v=rand 1000}"
    assert_equal v, @engine.eval('globalVar')
  end

  def shag_coffee
    @engine.exec File.read CoffeeScript::Source.bundled_path
    assert @engine.call('CoffeeScript.compile', "->")['function']
    r=rand 100
    assert_equal [r], @engine.eval(@engine.call 'CoffeeScript.compile', "do->[#{r}]", bare: true)
  end

  def klas_methods
    assert_equal 4, @class.exec('return 2*2')
    assert_equal 6, @class.eval('({x: 1+2+3}).x')
  end

  def klas_compile
    x=@class.compile <<-EOJ
      inc = function(x)
      {
        return x+1
      }
    EOJ
    assert_equal 6, x.call('inc', 5)
  end

  def engines
    (1..Spawn).map do
      Engines.map{|k| k::Valid ? k.compile : nil }
    end
  end

  def self.build
    instance_methods(false).grep(/^shag_/).each do |m|
      Engines.each_with_index  do |klass, idx|
        (1..Spawn).each do |n|
          define_method("test_#{m.to_s.sub /.*?_/, ''}_#{klass.name.split(/\W+/).last}_#{n}")do
            skip unless @engine=(@@engines||=engines)[n-1][idx]
            send m
          end
        end
      end
    end

    instance_methods(false).grep(/^klas_/).each do |m|
      Engines.each do |klass|
          define_method("test_#{m.to_s.sub /.*?_/, ''}_#{klass.name.split(/\W+/).last}_class")do
            skip unless klass::Valid
            @class=klass
            send m
          end
      end
    end
  end

  build

  Minitest.after_run do
    puts "Statistics:"
    M.stats.each{|k, v| puts " #{k}: "+v.map{|k, v| "#{k}=#{v.round(3).to_s.sub /[.]0*$/, ''}"}*', ' }
  end

end
