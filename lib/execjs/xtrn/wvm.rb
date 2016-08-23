#
# Virtual machine interface to Windows Script Host
#
require_relative 'wsh'

class ExecJS::Xtrn::Wvm < ExecJS::Xtrn::Wsh
  include ExecJS::Xtrn::VM

  # Force 32-bit cscript
  def self.patch64
    return unless Gem.win_platform?
    return unless File.exist? exe =
      File.join(ENV['windir'], 'syswow64/cscript.exe')
    args = Run[:args].dup
    args[0] = exe
    @run32 = Run.merge args: args
  end
  Run = @run32 if self.patch64
end
