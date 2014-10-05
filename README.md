# ExecJS::Xtrn

Drop-in replacement for ExecJS with persistent external runtime.

This is just proof of concept, not suitable for production.

Not on MS Windows, you should use excellent `therubyracer` gem instead.

## Installation

Add this line to your application's Gemfile:

    gem 'execjs-xtrn'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install execjs-xtrn

## Usage

Just add/require this gem after/instead (implicit) `execjs` gem.
The latter will be monkey-patched.


## Credits

  * [ExecJS](https://github.com/sstephenson/execjs)
  * [therubyracer](https://github.com/cowboyd/therubyracer)
  * [Node.js](http://nodejs.org/)
  * [Windows Script Host](http://en.wikipedia.org/wiki/Windows_Script_Host)
