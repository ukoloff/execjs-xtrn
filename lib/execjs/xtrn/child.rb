require 'json'

class ExecJS::Xtrn::Child

  @@stats={c: 0} # children

  def say(obj)
    delta={
      n: 1, # say calls
      o: 0, # out bytes
      i: 0, # in bytes
      t: Time.now # time spent
    }
    @stdin.puts delta[:o]=JSON.generate([obj])[1...-1]
    i=@stdout.gets

    delta[:t]=Time.now-delta[:t]
    delta[:i]=i.length
    delta[:o]=delta[:o].length
    @stats.each{|var| delta.each{|k, v| var[k]||=0; var[k]+=v}}

    JSON.load i
  end

  def self.stats
    @@stats.dup
  end

  def stats(*recs)
    @stats+=recs
    @stats[0].dup
  end

  private

  def initialize(options)
    i=IO.pipe
    o=IO.pipe

    @pid=spawn *options[:args],
      chdir: File.expand_path("../../#{options[:path]}", __FILE__),
      in:    i[0],
      err:   o[1]
    i[0].close
    o[1].close
    @stdin=i[1]
    @stdout=o[0]
    if options[:encoding]
      @stdin.set_encoding options[:encoding]
      @stdout.set_encoding options[:encoding]
    end
    @@stats[:c]+=1
    @stats=[{}, @@stats]
  end

end
