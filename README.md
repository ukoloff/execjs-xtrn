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

## Credits

  * [ExecJS](https://github.com/sstephenson/execjs)
  * [therubyracer](https://github.com/cowboyd/therubyracer)
  * [Node.js](http://nodejs.org/)
  * [Windows Script Host](http://en.wikipedia.org/wiki/Windows_Script_Host)
