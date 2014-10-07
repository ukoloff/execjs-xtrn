module ExecJS::Xtrn

  Engines=[Node, Nvm, Wsh]

  attr :engine

  def self.init
    # Find best available Engine
    engine=Engines.find{|k| k::Valid} || Engine
    # Install into ExecJS
    sc=(class<<ExecJS;self;end)
    Engine.methods(false).each{|m| sc.instance_eval{define_method(m){|*args| engine.send m, *args }}}
  end

  init

end
