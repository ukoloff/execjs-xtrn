class TestEngine < Minitest::Test

  M=ExecJS::Xtrn

  Spawn=2
  Engines=[M::Node, M::Wsh]

  def shag_exec
    assert_equal 42, @engine.exec('return 6*7')
  end

  def shag_eval
    assert_equal 42, @engine.eval('6*7')
  end

  def shag_call
    assert_equal 79, @engine.call('Math.max', 44, 27, 79, 73, 42, 4, 23, 24, 36, 13)
  end

  def engines
    (1..Spawn).map do
      Engines.map{|k| k::Valid ? k.new : nil }
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
  end

  build


end
