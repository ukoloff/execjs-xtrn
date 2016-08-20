require 'coffee_script/source'

class TestEngine < Minitest::Test

  M=ExecJS::Xtrn

  Spawn=5
  Engines=M::Engines << M::Ole
  Engines.each{|e| e::Preload=[]}
  M::Engine::Preload=[]

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

    assert_raises(M::Error){ @engine.eval '_load' }
    @engine.load File.expand_path '../load.js', __FILE__
    assert_equal ({}), @engine.eval('_load')
    @engine.load '_load.a=108'
    assert_equal ({"a"=>108}), @engine.eval('_load')
  end

  def shag_vars
    assert_raises(M::Error){ @engine.eval 'localVar' }
    refute @engine.exec 'var localVar=1'
    assert_raises(M::Error){ @engine.eval 'localVar' }

    assert_raises(M::Error){ @engine.eval 'globalVar' }
    refute @engine.exec "globalVar=#{v=rand 1000}"
    assert_equal v, @engine.eval('globalVar')
  end

  def shag_coffee
    @engine.exec File.read CoffeeScript::Source.bundled_path
    assert_equal 3, @engine.call('CoffeeScript.compile', "->").split(/\Wfunction\W/).length
    r=rand 100
    assert_equal [r], @engine.eval(@engine.call 'CoffeeScript.compile', "do->[#{r}]", bare: true)
    assert_equal 3, @engine.call('CoffeeScript.eval', 'Math.round Math.PI')
  end

  def shag_stats
    @engine.exec '//'
    s=@engine.stats
    @engine.exec ' '
    assert_equal s[:n], @engine.stats[:n]
    @engine.exec '[]'
    assert_equal s[:n]+1, @engine.stats[:n]
    assert_equal 1, M::Nvm.stats[:c]||1
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

  def klas_load
    z=@class.load File.expand_path '../load.js', __FILE__
    assert_equal ({}), z.eval('_load')
  end

  def klas_preload
    res=@class.ancestors.reverse.map do |k|
      defined?(k::Preload) ?
        k.name.sub(/.*\W/, '')
      :
        nil
    end.compact * ', '

    Spawn.times do
      begin
        Engines.each{|e| e::Preload << "_preload.#{e.name.sub(/.*\W/, '')}=1"}

        M::Engine::Preload << '!function(){this._preload={Engine: 1}}()'

        assert_equal res, @class.eval('_preload').keys * ', '

      ensure
        Engines.each{|e| e::Preload.clear}
        M::Engine::Preload.clear
      end
    end
  end

  def self.build
    Engines.each do |klass|
      valid = klass::Valid
      kname=klass.name.split(/\W+/).last
      prefix = "test_#{kname}::"
      instance_methods(false).grep(/^klas_/).each do |m|
        define_method  prefix + m.to_s.sub(/.*?_/, '') do
          skip unless valid
          @class=klass
          send m
        end
      end
      (1..Spawn).each do |n|
        prefix = "test_#{kname}[#{n}]"
        engine = klass.new if valid
        instance_methods(false).grep(/^shag_/).each do |m|
          define_method  prefix + m.to_s.sub(/.*?_/, '') do
            skip unless valid
            @engine = engine
            send m
          end
        end
      end
    end
  end

  build

end
