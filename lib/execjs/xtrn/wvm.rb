#
# Virtual machine interface to Windows Script Host
#
require_relative 'wsh'

class ExecJS::Xtrn::Wvm < ExecJS::Xtrn::Wsh
  include ExecJS::Xtrn::VM
end
