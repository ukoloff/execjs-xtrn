require_relative 'nvm'

class ExecJS::Xtrn::Wsh < ExecJS::Xtrn::Engine

  Run={
    args: %w(cscript //Nologo //U repl.js),
    path: 'wsh',
    encoding: 'UTF-16LE:UTF-8',
  }

  ES5 = File.expand_path('../../wsh/es5.js', __FILE__)

  Valid=Gem.win_platform?

  bear.say '//' rescue nil if Valid # Warm up
end
