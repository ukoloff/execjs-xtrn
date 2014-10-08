class ExecJS::Xtrn::Engine

  Run=nil # Abstract class

  @@stats={c: 0}

  def exec(code)
    return if (code=code.to_s.strip).length==0
    result=child.say code
    result={'err'=>'Invalid JS result'} unless Hash===result
    raise RuntimeError, result['err'] if result['err']
    result['ok']
  end

  def eval(code)
    return if (code=code.to_s.strip).length==0
    exec "return eval(#{JSON.generate([code])[1...-1]})"
  end

  def call(fn, *args)
    eval "(#{fn}).apply(this, #{JSON.dump args})"
  end

  def self.exec(code)
    new.exec code
  end

  def self.eval(code)
    new.eval code
  end

  def self.compile(code='')
    new.tap{|ctx| ctx.exec code}
  end

  def self.stats
    (@stats||@@stats).dup
  end

  def stats
    (@stats||{}).dup
  end

  private

  def child
    return @child if @child
    raise NotImplementedError, self.class.name unless self.class::Run
    @child=child=ExecJS::Xtrn::Child.new self.class::Run
    child.stats @stats={}, @@stats, classStats=self.class.class_eval('@stats||={c: 0}')
    @@stats[:c]+=1
    classStats[:c]+=1
    child
  end

end
