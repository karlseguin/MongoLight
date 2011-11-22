# MongoLight #
MongoLight is a lightweight object-relational mapper for Rails and MongoDB. It is **not** ActiveRecord compatible. Rather, the primary purpose is to be a thin wrapper around the excellent core [MongoDB driver](https://github.com/mongodb/mongo-ruby-driver). 

The only Rails dependency is on ActiveSupport::Concern.

The wrapper fits a specific use-case (mine).

## Setup ##
Configure MongoLight via `MongoLight.configure`:

	MongoLight.configure do |config|
	  config.connection = Mongo::Connection.new
	  config.database = 'mongolight_tests'
	end

This'll automatically handle Passenger forking issues (if Passenger is running).

## replica cocnern and testing ##
For safe writes, I like to use `w:majority`. However, MongoDB will raise an exception if you use this while not using replica sets. This can make testing code more of a pain than necessary. If you configure MongoLight with `config.skip_replica_concern = true`, then `:w => X` or `:w => :majority` will automatically be stripped when calling `save(:w => majority)` or `save!(:w => 3)`. (For example, you could do `config.skip_replica_concern =  Rails.env.test?`)

## Documents ##
To define a document include `MongoLight::Document` and define your properties using the `mongo_accessor` method:

	class User
		include MongoLight::Document
		mongo_accessor({:name => :name, password => :pw, :email => :e})
	end

Within your code, you can access the `name`, `password` and `email` properties. However, internally, MongoDB will store the fields as `name`, `pw` and `e` (document databases store the field names with each document, this can save a lot of space (we saved 25%)).

## Document Manipulation ##
Most of what you can do on a MongoDB collection (again, the Ruby driver), you can do on a MongoLight document:

	#string ids which are valid BsonIds will automatically get converted
	User.find_by_id(some_id)
	User.find_one(hash_selector)
	User.find(selector, options)
	User.remove(selector)
	User.update(selector, new_document, options)

In addition to any options which the ruby driver supports, the `find` method can be passed ``{:raw => true}` which'll cause a hash to be returned rather than a mapped object.

Instances can be saved via `save` or `save!` (safe mode).

New instances can be created by passing a hash into the constructor:

	User.new({:name => 'goku', :password => 'over 9000!!!'})

Finally, you can always access the underlying `collection` from a class or object (`User.collection` or `user.collection`).

## Embedded Documents ##
Embedded documents are supported. First, define an embedded document using `include MongoLight::EmbeddedDocument` and the same `mongo_accessor` method:

	class Comment
		include MongoLight::EmbeddedDocument
		mongo_accessor({:title => :t, description => :d})
	end

Next, use the following fancy syntax for your root document:

	class User
		include MongoLight::Document
		mongo_accessor({:name => :name, password => :pw, :email => :e, :comment => {:field => :c, :class => Comment}})
	end

Again, this'll make `comments` accessible on your objects, but store it within the `c` field.

If you want an array of embedded documents, simply specify `:array => true`:

	...
	:comments => {:field => :c, :class => Comment, array => true}})

Please note that aliasing completely fails when querying embedded documents - you need to use the shortened name:

	User.find({:name => 'blah', 'c.t' => 'blah2}) #yes, it sucks



	