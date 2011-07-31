require 'child'
class Parent
  include MongoLight::Document
  mongo_accessor({
    :name => :name, 
    :child => {:field => :c, :class => Child}})
end