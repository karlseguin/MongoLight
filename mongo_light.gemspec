require File.expand_path('../lib/mongo_light/version', __FILE__)

Gem::Specification.new do |s|
  s.name               = 'mongo_light'
  s.homepage           = 'http://github.com/karlseguin/MongoLight'
  s.summary            = 'A Lightweight ORM for Rails and MongoDB'
  s.require_path       = 'lib'
  s.authors            = ['Karl Seguin']
  s.email              = ['karl@openmymind.net']
  s.version            = MongoLight::Version
  s.platform           = Gem::Platform::RUBY
  s.files              = Dir.glob("{lib}/**/*") + %w[license readme.markdown]
end