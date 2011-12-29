require 'spec_helper'

describe 'remove behavior' do  
  it "removes the matching documents" do
    FactoryGirl.create(:simple, {:name => 'paul', :power => 49})
    FactoryGirl.create(:simple, {:name => 'jessica', :power => 123})
    Simple.remove({:power => 49})
    Simple.count.should == 1
    Simple.count({:name => 'jessica'}).should == 1
  end
  
  it "removes the matching documents with options" do
    FactoryGirl.create(:simple, {:name => 'paul', :power => 49})
    FactoryGirl.create(:simple, {:name => 'jessica', :power => 123})
    r = Simple.remove({:power => 49}, {:safe => true})
    r['n'].should == 1
  end
  
  it "removes all documents" do
    FactoryGirl.create(:simple, {:name => 'paul', :power => 49})
    FactoryGirl.create(:simple, {:name => 'jessica', :power => 123})
    Simple.remove
    Simple.count.should == 0
  end
  
  it "removes no document" do
    FactoryGirl.create(:simple, {:name => 'paul', :power => 49})
    FactoryGirl.create(:simple, {:name => 'jessica', :power => 123})
    Simple.remove({:over9000 => true})
    Simple.count.should == 2
  end
end