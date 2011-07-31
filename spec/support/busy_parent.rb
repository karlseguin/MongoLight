require 'child'
class BusyParent
  include MongoLight::Document
  mongo_accessor({
    :name => :name, 
    :children => {:field => :c, :class => Child, :array => true}})
end