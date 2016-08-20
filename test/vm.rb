require_relative 'shagi'

class TestVm < Shagi

  Children=[M::Nvm, M::Wvm]

  def say(code)
    @child.say vm: @vm, js: code
  end

  def self.build
    Children.each do |ch|
      valid = ch::Valid
      prefix = "test_#{ch.name.split(/\W+/).last}_"
      child = M::Child.new ch::Run if valid
      (1..Spawn).each do |n|
        vm = child.say(vm: 0)['vm'] if valid
        ancestors[1].instance_methods(false).grep(/^shag_/).each do |m|
          define_method("#{prefix}#{m.to_s.sub(/.*?_/, '')}_#{n}")do
            skip unless valid
            @child = child
            @vm = vm
            send m
          end
        end
      end
    end
  end

  build

end
