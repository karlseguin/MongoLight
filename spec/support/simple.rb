class Simple
  include MongoLight::Document
  mongo_accessor({:name => :n, :power => :p})
end
