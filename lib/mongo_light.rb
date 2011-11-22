require 'mongo_light/configuration'
require 'mongo_light/id'
require 'mongo_light/connection'
require 'mongo_light/embedded_document'
require 'mongo_light/document'
require 'mongo_light/mongo_extensions'

module MongoLight
  class << self
    attr_accessor :configuration
    
    def configuration
      @configuration ||= Configuration.new
    end
    
    def configure
      yield(configuration)
      MongoLight::Connection.setup(configuration)
    end
  end
end