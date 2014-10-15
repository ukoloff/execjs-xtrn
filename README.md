# ExecJS::Xtrn

[![Build Status](https://travis-ci.org/ukoloff/execjs-xtrn.svg?branch=master)](https://travis-ci.org/ukoloff/execjs-xtrn)
[![Gem Version](https://badge.fury.io/rb/execjs-xtrn.svg)](http://badge.fury.io/rb/execjs-xtrn)

Drop-in replacement for ExecJS. The latter spawns separate process for every JavaScript compilation
(when using external runtime),
while ExecJS::Xtrn spawn long running JavaScript process and communicates with it via stdin & stderr.

This is just proof of concept, not suitable for production.

When not on MS Windows, one definitely should use ExecJS with excellent `therubyracer` gem instead.

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

## Engines

## API

ExecJS::Xtrn is primarily designed to power other gems that use popular ExecJS.

But it has his own API (similar to ExecJS' API) and can be used itself.

In general one should create instance of an Engine and then feed it with JavaScript code:

```ruby
ctx=ExecJS::Xtrn::Wsh.new
ctx.exec 'fact = function(n){return n>1 ? n*fact(n-1) : 1}'
puts "10!=#{ctx.call 'fact', 10}"
```
Every execution context has three methods:
  * exec('`code`') -  executes arbitrary JavaScript code. To get result `return` must be called.
  * eval('`expression`') - evaluate JavaScript expression. `return` is not needed
  * call(`function`, arguments...) - special form of eval for function call

Engine class also has exec and eval methods, they just create brand new execution context,
pass argument to it, destroy that context and return its result. Using these class methods
is not recommended, since it's just what ExecJS does (except for Nvm engine).

Engine class also has compile method that combines `new` and `exec` and returns execution context.
This is how ExecJS is used in most cases.

```ruby
ctx=ExecJS::Xtrn::Wsh.compile 'fact = function(n){return n>1 ? n*fact(n-1) : 1}'
puts "10!=#{ctx.call 'fact', 10}"
```

And finally ExecJS::Xtrn patches ExecJS and installs those 3 class methods (exec, eval, compile) in it.
So, `ExecJS.compile` is `ExecJS::Xtrn::Nvm.compile` if Nvm engine is available.

## Overriding ExecJS

Sometimes ExecJS is required after ExecJS::Xtrn. In that case you can call ExecJS::Xtrn.init and
it will overwrite ExecJS' methods again.

To test whether JavaScript is served by ExecJS::Xtrn, it's convenient to look at ExecJS::Xtrn statistics.

## Statistics

Every engine gathers it's own usage statistics. Eg:

```ruby
> ExecJS::Xtrn::Node.stats # or ExecJS::Xtrn::Nvm.stats or ExecJS::Xtrn::Wsh.stats
=> {:c=>2, :n=>2, :o=>8, :i=>6, :t=>0.131013}
```
Here:
  * c = number of child processes spawned (for Nvm c should always be 1)
  * n = number of request made
  * o = bytes sent to child process(es)
  * i = bytes got from child process(es)
  * t = seconds spent communicating with child process(es)
  * m = number of VMs created (Nvm only)
  * x = number of VMs destroyed (Nvm only)

ExecJS::Xtrn.stats combines statistics for all its engines, even unused.

ExecJS.stats shows statistics for current engine only.

Every execution context has his own statistics too. Eg

```ruby
s=ExecJS::Xtrn::Nvm.compile '...'
s.exec '...'
s.stats
```
but c (and m, x) fields are omitted there.

## Compatibilty

Not every JavaScript code behaves identically in ExecJS and ExecJS::Xtrn. In most cases it depends on how
global JavaScript variables are used. For most modern code it is the same though.

As a rule of thumb, JavaScript code must survive after wrapping in anonymous function (`(function(){...})()`).

For instance, old versions of `handlebars_assets` didn't work
in ExecJS::Xtrn (and worked in ExecJS).

The following packages have been tested to run under ExecJS::Xtrn out-of-box:

  * [CoffeeScript](http://coffeescript.org/) via [coffee-script](https://rubygems.org/gems/coffee-script) and [coffee-rails](https://rubygems.org/gems/coffee-rails) gems
  * [UglifyJS2](https://github.com/mishoo/UglifyJS2) via [uglifier](https://github.com/lautis/uglifier)
  * [Handlebars](http://handlebarsjs.com/) via [handlebars_assets](https://github.com/leshill/handlebars_assets) gem

## Credits

  * [ExecJS](https://github.com/sstephenson/execjs)
  * [therubyracer](https://github.com/cowboyd/therubyracer)
  * [Node.js](http://nodejs.org/)
  * [Windows Script Host](http://en.wikipedia.org/wiki/Windows_Script_Host)
