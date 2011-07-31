class Child
  include MongoLight::EmbeddedDocument
  mongo_accessor({:name => :n, :power => :p})
end

  