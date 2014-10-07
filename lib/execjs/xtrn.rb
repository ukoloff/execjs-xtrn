%w(
version
engine
child
wsh
node
nvm
init
).each{|x| require_relative "xtrn/#{x}"}
