%w(wsh nvm).each{|x| require_relative "xtrn/#{x}"}

module ExecJS::Xtrn

  Engines=[Nvm, Node, Wsh]

  class << self
    attr_accessor :engine
  end

  # Find best available Engine
  self.engine=Engines.find{|k| k::Valid} || Engine

  # Install into ExecJS
  def self.init
    slf=self
    sc=(class<<ExecJS;self;end)
    Engine.methods(false).each{|m| sc.instance_eval{define_method(m){|*args| slf.engine.send m, *args }}}
  end

  init

  def self.stats
    Hash[([Child, Engine]+Engines).map{|k| [k.name.sub(/.*\W/, ''), k.stats]}]
  end

end
