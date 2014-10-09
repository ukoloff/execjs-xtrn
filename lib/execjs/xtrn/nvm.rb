# Interface to Node's vm
class ExecJS::Xtrn::Nvm < ExecJS::Xtrn::Node

  def exec(code)
    return if (code=code.to_s.strip).length==0
    ch, vmn = vm
    result=ch.say vm: vmn, js: code
    result={'err'=>'Invalid JS result'} unless Hash===result
    raise RuntimeError, result['err'] if result['err']
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
    raise RuntimeError, 'Cannot create VM' unless vm
    [@@child, @vm=vm]
  end

end
