class ExecJS::Xtrn::Wsh < ExecJS::Xtrn::Engine

  Run={
    :args=>%w(cscript //Nologo //U repl.js),
    :path=>'wsh',
    :encoding=>'UTF-16LE:UTF-8',
  }

  Valid=Gem.win_platform?

end
