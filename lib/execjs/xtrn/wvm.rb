#
# Virtual machine interface to Windows Script Host
#
require_relative 'wsh'
require_relative 'vm'

class ExecJS::Xtrn::Wvm < ExecJS::Xtrn::Wsh
  extend ExecJS::Xtrn::VM
end
