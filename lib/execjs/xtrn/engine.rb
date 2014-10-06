class ExecJS::Xtrn::Engine

  Run=nil # Abstract class

  def exec(code)
    return if (code=code.to_s.strip).length==0
    raise NotImplementedError unless self.class::Run
    result=(@child||=ExecJS::Xtrn::Child.new self.class::Run).say code
    raise RuntimeError, result['err'] if result['err']
    result['ok']
  end

  def eval(code)
    return if (code=code.to_s.strip).length==0
    exec "return eval(#{JSON.dump code})"
  end

  def call(fn, *args)
    eval "(#{fn}).apply(this, #{JSON.dump args})"
  end

end
