require_relative 'vm'

class ExecJS::Xtrn::Node < ExecJS::Xtrn::Engine

  Run={
    args: %w(? .),
    path: 'node',
  }

  Names=%w(nodejs node iojs)

  def self.valid?
    i=Names.index do |n|
      Run[:args][0]=n
      {"ok"=>42}==ExecJS::Xtrn::Child.new(Run).say('return 7*6') rescue nil
    end
    Run[:args][0]='!' unless i
    !!i
  end

  Valid=valid?

end
