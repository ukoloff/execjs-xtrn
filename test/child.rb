require_relative 'shagi'

class TestChild < Shagi

  Spawn=2
  Children=[M::Node, M::Wsh]

  def say(code)
    @child.say code
  end

  def children
    (1..Spawn).map do
      Children.map{|k| k::Valid ? M::Child.new(k::Run) : nil }
    end
  end

  def self.build
    ancestors[1].instance_methods(false).grep(/^shag_/).each do |m|
      Children.each_with_index  do |klass, idx|
        (1..Spawn).each do |n|
          define_method("test_#{m.to_s.sub /.*?_/, ''}_#{klass.name.split(/\W+/).last}_#{n}")do
            skip unless @child=(@@children||=children)[n-1][idx]
            send m
          end
        end
      end
    end
  end

  build

end
