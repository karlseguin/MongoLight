require 'spec_helper'

describe 'embedded array behavior' do  
  it "saves a single embedded document" do
    child = Child.new({:name => 'child', :power => 88})
    parent = BusyParent.new({:name => 'my name', :children => [child]})
    parent.save
    found = BusyParent.find_one({:name => 'my name'})
    found.children.length.should == 1
    found.children[0].name.should == 'child'
    found.children[0].power.should == 88
  end
  it "saves a muliple embedded document" do
    child1 = Child.new({:name => 'child1', :power => 88})
    child2 = Child.new({:name => 'child2', :power => 89})
    parent = BusyParent.new({:name => 'my name', :children => [child1, child2]})
    parent.save
    found = BusyParent.find_one({:name => 'my name'})
    found.children.length.should == 2
    found.children[0].name.should == 'child1'
    found.children[0].power.should == 88
    found.children[1].name.should == 'child2'
    found.children[1].power.should == 89
  end
end