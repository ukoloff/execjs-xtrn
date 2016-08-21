require_relative 'child'

class ExecJS::Xtrn::Error < RuntimeError
end

class ExecJS::Xtrn::Engine

  Error = ExecJS::Xtrn::Error

  Run=nil # Abstract class

  def exec(code)
    return if (code=code.to_s.strip).length==0
    result=child.say code
    result={'err'=>'Invalid JS result'} unless Hash===result
    raise Error, result['err'] if result['err']
    result['ok']
  end

  PathX=[/^[.]{1,2}\/|^\/[^\s\/*]/]
  PathX << /^[.]{0,2}\\|^\w:\S/ if Gem.win_platform?

  def load code
    exec PathX.find{|re| re.match code} ? File.read(code) : code
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

  def self.load code
    new.tap{|ctx| ctx.load code}
  end

  def self.stats
    (@stats||{}).dup
  end

  def stats
    (@stats||{}).dup
  end

  private

  def self.class_stats(increment = 1)
    s = @stats ||= {c: 0}
    s[:c] += increment
    s
  end

  def self.bear
    raise NotImplementedError, self unless self::Run
    ExecJS::Xtrn::Child.new self::Run
  end

  def child
    return @child if @child
    raise NotImplementedError, self.class unless self.class::Run
    child = ExecJS::Xtrn::Child.new self.class::Run
    child.stats @stats = {},
      self.class.class_stats,
      ExecJS::Xtrn::Engine.class_stats
    @child = child
  end

  def initialize
    self.class.ancestors.reverse.map do |m|
      list=m.const_get 'Preload', false rescue nil
      list ? Array===list ? list : [list] : []
    end
    .flatten.uniq.each{|code| load code}
  end
end
