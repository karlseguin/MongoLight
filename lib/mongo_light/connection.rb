require 'mongo'

module MongoLight
  module Connection 

    def self.setup(connection, database_name)
      @@connection = connection
      @@database = @@connection.db(database_name)
      handle_passenger_forking
    end
    
    def self.connection
      @@connection
    end
    
    def self.database
      @@database
    end
  
    def self.collections
      @@database.collections
    end

    def self.[](collection_name)
      @@database.collection(collection_name)
    end
  
    def self.handle_passenger_forking
      if defined?(PhusionPassenger)
        PhusionPassenger.on_event(:starting_worker_process) do |forked|
          @@connection.connect if forked
        end
      end
    end
  end
end