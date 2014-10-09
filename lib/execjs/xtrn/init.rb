module ExecJS::Xtrn

  Engines=[Nvm, Node, Wsh]

  attr :engine

  def self.init
    # Find best available Engine
    engine=Engines.find{|k| k::Valid} || Engine
    # Install into ExecJS
    sc=(class<<ExecJS;self;end)
    Engine.methods(false).each{|m| sc.instance_eval{define_method(m){|*args| engine.send m, *args }}}
  end

  init

  def self.stats
    Hash[([Child, Engine]+Engines).map{|k| [k.name.split(/\W+/).last, k.stats]}]
  end

end
