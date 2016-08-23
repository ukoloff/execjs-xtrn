source 'https://rubygems.org'

# Specify your gem's dependencies in execjs-xtrn.gemspec
gemspec

gem 'json', "#{/^1[.]/.match(RUBY_VERSION)? '~>' : '>='} 1.8"
gem "appveyor-worker" if ENV['APPVEYOR_API_URL']
