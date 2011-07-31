require 'spec_helper'

describe 'remove behavior' do  
  it "removes the matching documents" do
    Factory.create(:simple, {:name => 'paul', :power => 49})
    Factory.create(:simple, {:name => 'jessica', :power => 123})
    Simple.remove({:power => 49})
    Simple.count.should == 1
    Simple.count({:name => 'jessica'}).should == 1
  end
  
  it "removes all documents" do
    Factory.create(:simple, {:name => 'paul', :power => 49})
    Factory.create(:simple, {:name => 'jessica', :power => 123})
    Simple.remove
    Simple.count.should == 0
  end
  
  it "removes no document" do
    Factory.create(:simple, {:name => 'paul', :power => 49})
    Factory.create(:simple, {:name => 'jessica', :power => 123})
    Simple.remove({:over9000 => true})
    Simple.count.should == 2
  end
end