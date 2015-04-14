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

ExecJS::Xtrn uses two external JavaScript runners:

  * Windows Script Host
  * Node.js in two modes:
    - Simple (1 execution context = 1 external process)
    - Nvm (all execution contexts share single external process using [vm API](http://nodejs.org/api/vm.html))

Nvm engine has nothing common with [nvm](https://github.com/creationix/nvm).

So, there exist *four* engines:

  * Engine - absctract engine (smart enough to execute blank lines)
  * Wsh - engine using WSH (CScript)
  * Node - engine using Node.js (separate process for every execution context)
  * Nvm - engine using Node.js and vm API (single process)

All engines autodetect their availability at startup (on `require 'execjs/xtrn'`) and sets `Valid` constants.
Eg on MS Windows ExecJS::Xtrn::Wsh::Valid = true, on Linux - false

One of available engines is made default engine for ExecJS.
If Node.js is available it is Nvm.
Else, if running on Windows it is Wsh.
Else it is Engine, so ExecJS is made unusable.

Default engine can be shown/changed at any moment with `ExecJS::Xtrn.engine` accessor, eg

```ruby
ExecJS::Xtrn.engine=ExecJS::Xtrn::Node
```

## API

ExecJS::Xtrn is primarily designed to power other gems that use popular ExecJS.

But it has his own API (similar to ExecJS' API) and can be used itself.

In general one should create instance of an Engine and then feed it with JavaScript code:

```ruby
ctx=ExecJS::Xtrn::Wsh.new
ctx.exec 'fact = function(n){return n>1 ? n*fact(n-1) : 1}'
puts "10! = #{ctx.call 'fact', 10}"
```
Every execution context has four methods:
  * exec(`code`) -  executes arbitrary JavaScript code. To get result `return` must be called
  * load(`code`) or load(`path`) - exec that can load its code from file
  * eval(`expression`) - evaluate JavaScript expression. `return` is not needed
  * call(`function`, arguments...) - special form of eval for function call

There are `exec` and `eval` methods in Engine class,
they just create brand new execution context,
pass argument to it, destroy that context and return its result.
Using these class methods is not recommended, since it's just what ExecJS does
(except for Nvm engine).

Engine class also has `compile` method that combines `new` and `exec`
and returns execution context.
This is how ExecJS is used in most cases.

```ruby
ctx=ExecJS::Xtrn::Wsh.compile 'fact = function(n){return n>1 ? n*fact(n-1) : 1}'
puts "10! = #{ctx.call 'fact', 10}"
```
And `load` methods is likewise combination of `new`+`load`,
it is `compile` that can load its code from file.

`load` method (class' or instance's) detects whether its argument
is code or path by first symbols of it. So, start path with `/`, `./`
or `../` (but not from `//`). On Windows `\` and `C:` can be also used.

Finally ExecJS::Xtrn patches ExecJS and installs those 4 class methods
(`exec`, `eval`, `compile` and `load`) in it.
So, `ExecJS.compile` is `ExecJS::Xtrn::Nvm.compile` if Nvm engine is available.

## Preloading

Sometimes it's neccesary to initialize all execution contexts before passing
code to them.
For instance, add some standard JavaScript methods missing in Wsh engine.

It can be done by setting Preload constant on engine class.

```ruby
ExecJS::Xtrn::Wsh::Preload='./lib/js/map.js'
```
or maybe

```ruby
ExecJS::Xtrn::Wsh::Preload=[
  './lib/js/map.js',
  './lib/js/keys.js',
  'console={log: function(){WScript.Echo([].slice.call(arguments).join(" "))}}'
  ]
# Yes, console.log is avaialable in Wsh now!
# And yes, console.log can be used in ExecJS::Xtrn!
```
You can add preload scripts to any engine or to Engine base class.
They will be loaded according to inheritance:
Engine::Preload will be used by all engines,
Node::Preload is for Node and Nvm, while Nvm::Preload is for Nvm only.

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

If ExecJS::Xtrn detects it is run under Ruby on Rails,
it installs additional path `/rails/jsx' to display its statistics
(you can see that route in sextant, for example).

It is one more reason not to use ExecJS::Xtrn in production mode ;-)

By default statistics is output in YAML format, but you can
get `/rails/jsx.json` or `/rails/jsx.html`.

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

CoffeeScript since v1.9.0 introduces new incompatibility:
it uses `Object.create` that is missing from WSH.
To fix it, `Object.create` was manually defined in ExecJS::Xtrn::Wsh
(sort of [ExecJS::Xtrn::Wsh::Preload](#preloading))

Gem [coffee-script](https://rubygems.org/gems/coffee-script) since v2.4.0 introduces another incompatibility:
it silently creates global function. This approach works in regular ExecJS but fails in ExecJS::Xtrn.
As a workaround pin `coffee-script` gem version to 2.3.0.

## Testing

After git checkout, required NPM modules must be installed. Simply run:

```
bundle install
bundle exec rake npm
```

The testing itself is

```
bundle exec rake
```

And `bundle exec` may be ommited in most cases.

## Credits

  * [ExecJS](https://github.com/sstephenson/execjs)
  * [therubyracer](https://github.com/cowboyd/therubyracer)
  * [Node.js](http://nodejs.org/)
  * [Windows Script Host](http://en.wikipedia.org/wiki/Windows_Script_Host)
