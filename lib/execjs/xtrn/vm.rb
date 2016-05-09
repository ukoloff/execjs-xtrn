#
# Using VM with Engine
#

module ExecJS::Xtrn::VM

  Error = ExecJS::Xtrn::Error

  def exec(code)
    return if (code=code.to_s.strip).length==0
    result=say vm: vm, js: code
    result={'err'=>'Invalid JS result'} unless Hash===result
    raise Error, result['err'] if result['err']
    result['ok']
  end

  private

  def child
    @@child||=super
  end

  def say(code)
    ch=@@child
    @stats[:once]=1
    ch.stats @stats
    ch.say code
  end

  def vm
    return @vm if @vm
    c=child
    @stats[:once]=1 if @stats # Remove @stats, added by Engine
    @stats={}                 # Our new stats
    vm=say({vm: 0})['vm']
    raise Error, 'Cannot create VM' unless vm
    cs=self.class.class_eval{@stats}
    cs[:m]||=0
    cs[:m]+=1
    ObjectSpace.define_finalizer(self)do
      cs[:x]||=0
      cs[:x]+=1
      c.say vm: vm rescue nil
    end
    @vm=vm
  end

end
