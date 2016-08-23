#
# Interface to Node's vm
#
require_relative 'node'

class ExecJS::Xtrn::Nvm < ExecJS::Xtrn::Node
  include ExecJS::Xtrn::VM
end
