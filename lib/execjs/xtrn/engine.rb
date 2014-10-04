class ExecJS::Xtrn::Engine
  attr_reader :stdin, :stdout

  def spawn(options)
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

  Node={
    args: %w(node .),
    path: 'node',
  }

  Wsh={
    args: %w(cscript //Nologo wsh.js),
    path: 'wsh',
  }
end
