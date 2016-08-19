require_relative 'wsh'

class ExecJS::Xtrn::Ole < ExecJS::Xtrn::Wsh

  class Error < ExecJS::Xtrn::Error
    def initialize error
      # In addition, say: $stdout.set_encoding Encoding.default_external
      super error.message.force_encoding Encoding.default_external
    end
  end

  def self.valid?
    return unless Gem.win_platform?
    require 'win32ole'
    WIN32OLE.new 'ScriptControl'
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
    begin
      result = parse vm.eval "new Function(#{JSON.dump code})()"
    rescue WIN32OLERuntimeError=>e
      raise Error.new e
    ensure
      delta[:t]=Time.now-delta[:t]
      delta[:o]=code.length
      delta[:i]=JSON.dump(result).length if result
      @statz.each{|var| delta.each{|k, v| var[k]||=0; var[k]+=v}}
    end
  end

  private

  Json2 = File.expand_path('../../wsh/json2.js', __FILE__)

  def vm
    return @vm if @vm
    @statz = [
      @stats||={},
      self.class.class_stats,
      ExecJS::Xtrn::Engine.class_stats(0)
    ]
    vm = WIN32OLE.new 'ScriptControl'
    vm.Language = 'JScript'
    vm.addCode File.read ES5
    @vm = vm
  end

  @@json = nil

  def json
    return @@json if @@json
    j = WIN32OLE.new 'ScriptControl'
    j.Language = 'JScript'
    j.addCode File.read Json2
    j.addCode <<-EOJ
      function jsonDump(o)
      {
        return JSON.stringify(o)
      }
    EOJ
    @@json = j
  end

  def parse result
    WIN32OLE===result ?
      JSON.parse(json.run 'jsonDump', result)
    :
      result
  end

end
