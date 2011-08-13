require 'spec_helper'

describe 'update behavior' do  
  it "updates the matching documents" do
    FactoryGirl.create(:simple, {:name => 'paul', :power => 2})
    FactoryGirl.create(:simple, {:name => 'jessica', :power => 2})
    Simple.update({:power => 2}, {'$set' => {:power => 4}}, {:multi => true})
    Simple.count.should == 2
    Simple.count({:power => 4}).should == 2
  end
  
  it "updates a single document" do
    FactoryGirl.create(:simple, {:name => 'paul', :power => 2})
    FactoryGirl.create(:simple, {:name => 'jessica', :power => 2})
    Simple.update({:power => 2}, {:power => 4})
    Simple.count.should == 2
    Simple.count({:power => 4}).should == 1
  end
  
  it "updates no document" do
    FactoryGirl.create(:simple, {:name => 'paul', :power => 49})
    FactoryGirl.create(:simple, {:name => 'jessica', :power => 123})
    Simple.remove({:over9000 => true, :power => 442})
    Simple.count.should == 2
    Simple.count({:power => 442}).should == 0
  end
end