module MongoLight
  class Configuration     
    attr_accessor :connection, :database, :skip_replica_concern
      
    def initialize
      @skip_replica_concern = false
    end
  end
end
