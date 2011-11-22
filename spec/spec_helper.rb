$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'support'))

Dir[File.join(File.dirname(__FILE__), '..', 'lib/*.rb')].each {|file| require file }
Dir[File.join(File.dirname(__FILE__), '..', 'lib/mongo_light/*.rb')].each {|file| require file }
Dir[File.join(File.dirname(__FILE__), 'support/*.rb')].each {|file| require file }

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.mock_with :rspec
  MongoLight.configure do |config|
    config.connection = Mongo::Connection.new
    config.database = 'mongolight_tests'
  end
  
  config.before(:each) do
    MongoLight::Connection.collections.each do |collection|
      collection.remove unless collection.name.match(/^system\./)
    end
  end
end


class String
  def tableize
    to_s
  end
end