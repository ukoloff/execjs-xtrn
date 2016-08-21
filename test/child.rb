require_relative 'shagi'

class TestChild < Shagi

  Children=[M::Node, M::Wsh]

  def say(code)
    @child.say code
  end

  def self.build
    Children.each  do |ch|
      valid = ch::Valid
      (1..Spawn).each do |n|
        child = M::Child.new ch::Run if valid
        prefix = "test_#{ch.name.split(/\W+/).last}[#{n}]"
        shagi.each do |k, v|
          define_method prefix + v do
            skip unless valid
            @child = child
            send k
          end
        end
      end
    end
  end

  build

end
