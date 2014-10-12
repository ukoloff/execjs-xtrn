require_relative 'shagi'

class TestNvm < Shagi

  Child=M::Nvm

  def say(code)
    # puts "s: child=#{@child} vm=#{@vm}, code=#{code}"
    r=@child.say vm: @vm, js: code
    # puts "r: #{r}"
    r
  end

  def buildVMs
    @@child=child=M::Child.new(Child::Run)
    (1..Spawn).map do
      child.say(vm: 0)['vm']
    end
  end

  def self.build
    ancestors[1].instance_methods(false).grep(/^shag_/).each do |m|
      (1..Spawn).each do |n|
        define_method("test_#{m.to_s.sub /.*?_/, ''}_#{n}")do
          skip unless Child::Valid
          @vm=(@@vms||=buildVMs)[n-1]
          @child=@@child
          send m
        end
      end
    end
  end

  build

end
