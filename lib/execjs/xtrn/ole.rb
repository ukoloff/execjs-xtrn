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
    result = nil
    delta={
      n: 1, # say calls
      i: 0, # in bytes
      o: 0, # out bytes
      t: Time.now # time spent
    }
    result = vm.eval "new Function(#{JSON.dump code})()"
  ensure
    delta[:t]=Time.now-delta[:t]
    delta[:i]=code.length
    delta[:o]=JSON.dump(result).length if result
    @statz.each{|var| delta.each{|k, v| var[k]||=0; var[k]+=v}}
  end

  private

  @stats = @@stats = {c: 0}

  def vm
    return @vm if @vm
    @stats||={}
    @@stats[:c]+=1
    @statz=[@stats, @@stats]
    @vm = WIN32OLE.new 'ScriptControl'
    @vm.Language = 'JScript'
    @vm
  end

end
