require 'spec_helper'

describe 'configurations' do
  it "provide default values" do
    assert_default_is_nil :connection, :database
    assert_default_config :skip_replica_concern, false
  end
 
  it "allows values to be set" do
    assert_value_set :connection, 'something.else.com'
    assert_value_set :database, 'mogade'
    assert_value_set :skip_replica_concern, true
  end
 
  private
  def assert_default_config(option, value)
    MongoLight::Configuration.new.send(option).should == value 
  end
  def assert_default_is_nil(*options)
    options.each do |option|
      MongoLight::Configuration.new.send(option).should be_nil
    end
  end
  def assert_value_set(option, value)
    config = MongoLight::Configuration.new
    config.send(:"#{option}=", value)
    config.send(option).should == value
  end
end