require_relative 'vm'

class ExecJS::Xtrn::Node < ExecJS::Xtrn::Engine

  Run={
    args: %w(? .),
    path: 'node',
  }

  Names=%w(nodejs node iojs)

  def self.valid?
    Names.each do |n|
      Run[:args][0] = n
      return true if {"ok"=>42} === bear.say('7*6') rescue nil
    end
    Run[:args][0]='!'
    false
  end

  Valid=valid?

end
