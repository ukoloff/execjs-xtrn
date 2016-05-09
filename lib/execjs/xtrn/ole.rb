require_relative 'wsh'

class ExecJS::Xtrn::Ole < ExecJS::Xtrn::Wsh

  def self.valid?
    return unless Gem.win_platform?
    require 'win32ole'
    true
  rescue
    false
  end

  Valid = valid?

  def exec code
    return if (code=code.to_s.strip).length==0
    vm.eval "new Function(#{JSON.dump code})()"
  end

  private

  def vm
    return @vm if @vm
    @vm = WIN32OLE.new 'ScriptControl'
    @vm.Language = 'JScript'
    @vm
  end

end
