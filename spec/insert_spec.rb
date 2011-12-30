require 'spec_helper'

describe 'insert behavior' do  
  before(:each) do
    Simple.collection.create_index([['name', Mongo::ASCENDING]], {:unique => true})
  end
  after(:each) do
    Simple.collection.drop_index('name_1')
  end
    
  it "inserts the document" do  
    Simple.insert({:itsover => 9000})
    Simple.count({:itsover => 9000}).should == 1
  end

  it "inserts the document with mapping" do  
    Simple.insert({:name => 'leto'})
    Simple.collection.count({:n => 'leto'}).should == 1
  end
  
  it "uses options" do  
    FactoryGirl.build(:simple, {:name => 'paul', :power => 49}).save!
    lambda{ Simple.insert({:name => 'paul', :power => 49}, {:safe => true})}.should raise_error(Mongo::OperationFailure)
    Simple.count.should == 1
  end
end