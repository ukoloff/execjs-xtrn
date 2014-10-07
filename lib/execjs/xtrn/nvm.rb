# Interface to Node's vm
class ExecJS::Xtrn::Nvm < ExecJS::Xtrn::Node

  private

  def child
    @@child||=super
  end

end
