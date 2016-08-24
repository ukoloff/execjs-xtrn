#
# Virtual machine interface to Windows Script Host
#
require_relative 'wsh'

class ExecJS::Xtrn::Wvm < ExecJS::Xtrn::Wsh
  include ExecJS::Xtrn::VM

  # Force 32-bit cscript
  def self.patch64
    args = Run[:args].dup
    exe = File.join ENV['windir'], 'syswow64/cscript.exe'
    args[0] = exe if File.exists? exe
    args.pop
    args.push 'replvm.js'
    Run.merge args: args
  end
  Run = self.patch64 if Valid
end
