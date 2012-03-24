require 'active_support'
module MongoLight
  module EmbeddedDocument
    extend ActiveSupport::Concern

    module ClassMethods
      def mongo_accessor(map)
        @map = map
        @unmap = {}
        map.each do |k,v|
          define_method(k) { @attributes[k] }
          define_method("#{k}=") {|value| @attributes[k] = value }
          if v.is_a?(Hash)
            @unmap[v[:field].to_s] = {:prop => k, :class => v[:class], :array => v[:array]}
          else
            @unmap[v.to_s] = k
          end
        end
      end
      def map(raw)
        return {} if raw.nil? || !raw.is_a?(Hash)
        hash = {}
        raw.each do |key, value|
          sym = key.to_sym
          if value.is_a?(EmbeddedDocument)
            v = value.class.map(value.attributes)
          elsif value.is_a?(Hash)
            v = map(value)
          elsif value.is_a?(Array) && @map[sym].is_a?(Hash) && @map[sym][:array]
            v = value.map{|vv| vv.class.map(vv.attributes)}
          else
            v = value
          end
          hash[map_key(sym)] = v
        end
        return hash
      end
      def map_options(options)
        options[:fields] = map(options[:fields]) if options.include?(:fields)
        options[:sort][0] = map_key(options[:sort][0]) if options.include?(:sort)
        options
      end
      def unmap(data, raw = false)
        return {} if data.nil? || !data.is_a?(Hash)
        hash = {}
        data.each do |key, value|
          if @unmap[key].is_a?(Hash)
            real_key = @unmap[key][:prop]
            c = @unmap[key][:class]
            if @unmap[key][:array]
              v = value.map{|vv| raw ? c.unmap(vv) : c.new(c.unmap(vv))}
            else
              v = raw ? c.unmap(value) : c.new(c.unmap(value))
            end
          else
            real_key = key == '_id' ? :_id : @unmap[key]
            v = value
          end
          hash[real_key] = v
        end
        hash
      end
      def map_key(key)
        return key unless @map.include?(key)
        @map[key].is_a?(Hash) ? @map[key][:field] : @map[key]
      end
      def map_include?(key)
        @map.include?(key)
      end
    end
    def initialize(attributes = {})
      @attributes = {}
      attributes.each do |k,v|
        if self.class.map_include?(k)
          @attributes[k] = v
        else
          send("#{k}=", v)
        end
      end
    end
    def [](name)
      @attributes[name]
    end
    def attributes
      @attributes
    end
  end
end