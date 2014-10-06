class ExecJS::Xtrn::Wsh

  Run={
    args: %w(cscript //Nologo repl.js),
    path: 'wsh',
  }

  Valid=Gem.win_platform?

end
