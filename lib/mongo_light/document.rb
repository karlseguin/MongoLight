module MongoLight
  module Document
    extend ActiveSupport::Concern
    include EmbeddedDocument
  
    module ClassMethods
      def collection
        Connection[self.to_s.tableize]
      end
      def find_by_id(id)
        real_id = Id.from_string(id)
        return nil if real_id.nil?
      
        found = collection.find_one(real_id)
        found.nil? ? nil : self.new(unmap(found))
      end
      def find_one(selector = {}, opts={})
        found = collection.find_one(map(selector))
        if found.nil?
          return nil
        end
        if opts.delete(:raw)
          return unmap(found, true)
        end
        self.new(unmap(found))
      end
      def find(selector={}, opts={}, collection = nil)
        raw = opts.delete(:raw) || false
        opts[:transformer] = Proc.new{|data| raw ? unmap(data, raw) : self.new(unmap(data)) }
        c = collection || self.collection
        c.find(map(selector), map_options(opts))
      end
      def remove(selector={}, collection = nil)
        c = collection || self.collection
        c.remove(map(selector))
      end
      def update(selector, document, options = {}, collection = nil)
        c = collection || self.collection
        c.update(map(selector), map(document), options)
      end
      def count(selector={}, collection = nil)
        c = collection || self.collection
        c.find(map(selector)).count
      end
    end
    module InstanceMethods
      def initialize(attributes = {})
        attributes = {} unless attributes
        @attributes = {:_id => (attributes['_id'] || attributes[:_id] || Id.new)}
        attributes.each do |k,v|
          if self.class.map_include?(k)
            @attributes[k] = v
          elsif k != :_id && k != '_id'
            send("#{k}=", v)
          end
        end
      end
      def eql?(other)
        other.is_a?(self.class) && id == other.id
      end
      alias :== :eql?
      def hash
        id.hash
      end
      def id
        @attributes[:_id] || @attributes['_id']
      end
      def id=(value)
        @attributes[:_id] = value
      end
      def ==(other)
        other.class == self.class && id == other.id
      end
      def collection
        self.class.collection
      end
      def save(options = nil)
        opts = !options || options.include?(:safe) ? options : {:safe => options}
        collection.save(self.class.map(@attributes), opts || {})
      end
      def save!(options = {})
        save({:safe => true}.merge(options))
      end
    end
  end
end