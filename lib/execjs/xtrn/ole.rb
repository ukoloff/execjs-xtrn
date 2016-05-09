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
      n: 1, # calls
      o: 0, # out bytes
      i: 0, # in bytes
      t: Time.now # time spent
    }
    result = vm.eval "new Function(#{JSON.dump code})()"
  rescue WIN32OLERuntimeError=>e
    raise Error.new "Win32::OLE Error"
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
    eStats = ExecJS::Xtrn::Engine.class_eval{@stats}
    eStats[:c]+=1
    @statz=[@stats, @@stats, eStats]
    @vm = WIN32OLE.new 'ScriptControl'
    @vm.Language = 'JScript'
    @vm
  end

end
