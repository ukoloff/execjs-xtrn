# Interface to Node's vm
class ExecJS::Xtrn::Nvm < ExecJS::Xtrn::Node

  def exec(code)
    return if (code=code.to_s.strip).length==0
    ch, vmn = vm
    result=ch.say vm: vmn, js: code
    result={'err'=>'Invalid JS result'} unless Hash===result
    raise Error, result['err'] if result['err']
    result['ok']
  end

  private

  def child
    @@child||=super
  end

  def vm
    return [@@child, @vm] if @vm
    c=child
    vm=c.say({vm: 0})['vm']
    raise Error, 'Cannot create VM' unless vm
    cs=self.class.class_eval{@stats}
    cs[:m]||=0
    cs[:m]+=1
    ObjectSpace.define_finalizer(self)do
      cs[:x]||=0
      cs[:x]+=1
      c.say vm: vm rescue nil
    end
    [@@child, @vm=vm]
  end

end
