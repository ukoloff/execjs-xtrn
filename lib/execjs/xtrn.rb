%w(
version
engine
child
wsh
node
nvm
init
rails
).each{|x| require_relative "xtrn/#{x}"}
