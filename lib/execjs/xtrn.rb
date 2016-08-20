require_relative "xtrn/rails"

module ExecJS::Xtrn

  Engines=[Nvm, Node, Wsh, Wvm, Ole]

  class << self
    attr_accessor :engine
  end

  # Find best available Engine
  self.engine=Engines.find{|k| k::Valid} || Engine

  # Install into ExecJS
  def self.init
    slf=self
    sc=(class << ExecJS; self ;end)
    Engine.methods(false).each do |m|
      sc.instance_eval do
        define_method(m) do |*args|
          slf.engine.send m, *args
        end
      end
    end
  end

  init

  def self.stats
    Hash[([Child, Engine]+Engines).map{|k| [k.name.sub(/.*\W/, ''), k.stats]}]
  end

end
