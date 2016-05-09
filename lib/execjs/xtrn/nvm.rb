#
# Interface to Node's vm
#
require_relative 'node'
require_relative 'vm'

class ExecJS::Xtrn::Nvm < ExecJS::Xtrn::Node
  include ExecJS::Xtrn::VM
end
