require_relative 'shagi'

class TestChild < Shagi

  Children=[M::Node, M::Wsh]

  def say(code)
    @child.say code
  end

  def self.build
    Children.each  do |ch|
      valid = ch::Valid
      prefix = "test_#{ch.name.split(/\W+/).last}_"
      (1..Spawn).each do |n|
        child = M::Child.new ch::Run if valid
        ancestors[1].instance_methods(false).grep(/^shag_/).each do |m|
          define_method("#{prefix}#{m.to_s.sub(/.*?_/, '')}_#{n}")do
            skip unless valid
            @child = child
            send m
          end
        end
      end
    end
  end

  build

end
