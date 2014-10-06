require 'json'

class ExecJS::Xtrn::Child

  def initialize(options)
    i=IO.pipe
    o=IO.pipe

    @pid=spawn *options[:args],
      chdir: File.expand_path("../../#{options[:path]}", __FILE__),
      in: i[0],
      err: o[1]
    i[0].close
    o[1].close
    @stdin=i[1]
    @stdout=o[0]
  end

  def say(obj)
    @stdin.puts JSON.dump obj
    JSON.load @stdout.gets
  end

end
