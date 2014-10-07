class ExecJS::Xtrn::Engine

  Run=nil # Abstract class

  def exec(code)
    return if (code=code.to_s.strip).length==0
    result=child.say code
    result={'err'=>'Invalid JS result'} unless Hash===result
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

  private

  def child
    return @child if @child
    raise NotImplementedError, self.class.name unless self.class::Run
    @child=ExecJS::Xtrn::Child.new self.class::Run
  end

end
