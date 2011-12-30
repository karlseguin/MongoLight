require 'spec_helper'

describe 'find and modify behavior' do
  it "returns nil if not found" do
    found = Simple.find_and_modify({:query => {:name => 'paul'}, :update => {'$set' => {:power => 9000}}})
    found.should be_nil
    Simple.count.should == 0
  end
  
  it "returns the found document before the update" do
    id = FactoryGirl.create(:simple, {:name => 'paul', :power => 49}).id
    found = Simple.find_and_modify({:query => {:name => 'paul'}, :update => {'$set' => {:power => 9000}}})
    found.name.should == 'paul'
    found.power.should == 49
    found.id.should == id
    Simple.count.should == 1
    Simple.count({:name => 'paul', :power => 9000}).should == 1
  end
  
  it "returns the found document afterthe update" do
    id = FactoryGirl.create(:simple, {:name => 'paul', :power => 49}).id
    found = Simple.find_and_modify({:new => true, :query => {:name => 'paul'}, :update => {'$set' => {:power => 22}}})
    found.name.should == 'paul'
    found.power.should == 22
    found.id.should == id
    Simple.count.should == 1
    Simple.count({:name => 'paul', :power => 22}).should == 1
  end
  
  it "returns the selected fields" do
    id = FactoryGirl.create(:simple, {:name => 'paul', :power => 49}).id
    found = Simple.find_and_modify({:raw => true, :fields => {:_id => false, :power => true}, :new => true, :query => {:name => 'paul'}, :update => {'$set' => {:power => 22}}})
    found.should == {:power => 22}
  end
end