#
# Using VM with Engine
#

require_relative 'engine'

module ExecJS::Xtrn::VM
  private

  Error = ExecJS::Xtrn::Error

  def self.included base
    def base.child # override class.child
      @child ||= super  # Single child for engine
    end
  end

  def child
    @child ||= self.class.child
  end

  def say code
    @stats ||= {}
    @stats[:once] = 1
    c = child
    c.stats @stats
    c.say vm: vm, js: code
  end

  def vm
    return @vm if @vm
    c = child
    vm = c.say({vm: 0})['vm']
    raise Error, 'Cannot create VM' unless vm
    cs = self.class.class_stats 0
    cs[:m] ||= 0
    cs[:m] += 1
    ObjectSpace.define_finalizer self do
      cs[:x] ||= 0
      cs[:x] += 1
      c.say vm: vm rescue nil
    end
    @vm = vm
  end

end
