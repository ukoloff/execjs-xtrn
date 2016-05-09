#
# Interface to Node's vm
#
require_relative 'node'
require_relative 'vm'

class ExecJS::Xtrn::Nvm < ExecJS::Xtrn::Node
  extend ExecJS::Xtrn::VM
end
