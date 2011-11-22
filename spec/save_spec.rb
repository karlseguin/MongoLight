require 'spec_helper'

describe 'save behavior' do
  before(:each) do
    Simple.collection.create_index([['name', Mongo::ASCENDING]], {:unique => true})
  end
  after(:each) do
    Simple.collection.drop_index('name_1')
  end
  
  it "normal saves the document using the aliased names" do
    expected = FactoryGirl.build(:simple, {:name => 'paul', :power => 49})
    expected.save
    Simple.collection.find({:n => 'paul', :p => 49, :_id => expected.id}).count.should == 1
  end
  
  it "safe save the document using the aliased names" do
    expected = FactoryGirl.build(:simple, {:name => 'jessica', :power => 1.1, :id => 3})
    expected.save!
    Simple.collection.find({:n => 'jessica', :p => 1.1, :_id => 3}).count.should == 1
  end  
  
  it "normal save fails silently" do
    FactoryGirl.build(:simple, {:name => 'paul', :power => 49, :id => 1}).save
    FactoryGirl.build(:simple, {:name => 'paul', :power => 49, :id => 1}).save
    Simple.count.should == 1
  end
  
  it "safe save raises an exception on error" do
    FactoryGirl.build(:simple, {:name => 'paul', :power => 49}).save!
    lambda{FactoryGirl.build(:simple, {:name => 'paul', :power => 49}).save!}.should raise_error(Mongo::OperationFailure)
    Simple.count.should == 1
  end
  
  it "can specify safe options" do
    FactoryGirl.build(:simple, {:name => 'paul', :power => 49}).save!
    lambda{FactoryGirl.build(:simple, {:name => 'paul', :power => 49}).save({:fsync => true})}.should raise_error(Mongo::OperationFailure)
    Simple.count.should == 1
  end
  
  it "can specify safe options" do
    FactoryGirl.build(:simple, {:name => 'paul', :power => 49}).save!
    lambda{FactoryGirl.build(:simple, {:name => 'paul', :power => 49}).save({:safe => {:fsync => true}})}.should raise_error(Mongo::OperationFailure)
    Simple.count.should == 1
  end
  
  it "can specify safe options" do
    FactoryGirl.build(:simple, {:name => 'paul', :power => 49}).save!
    lambda{FactoryGirl.build(:simple, {:name => 'paul', :power => 49}).save({:bah => true})}.should raise_error(ArgumentError)
    Simple.count.should == 1
  end
  
  it "does not skip majority write concern by default" do
    begin
      Simple.new.save(:w => true)
      true.should be_false
    rescue Mongo::OperationFailure => e
      e.message.should == ': norepl'
    end
  end
  
  it "skips majority write concern when told to do so" do
    MongoLight.configure do |config|
      config.skip_replica_concern = true
    end
    Simple.new.save(:w => true)
    Simple.count.should == 1
  end
end