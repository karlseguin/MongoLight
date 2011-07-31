require 'spec_helper'

describe 'embedded behavior' do  
  it "saves the embedded document" do
    child = Child.new({:name => 'child', :power => 88})
    parent = Parent.new({:name => 'my name', :child => child})
    parent.save
    found = Parent.find_one({:name => 'my name'})
    found.child.name.should == 'child'
    found.child.power.should == 88
  end
  it "returns the raw document with embedded objects" do
    child = Child.new({:name => 'child', :power => 88})
    parent = Parent.new({:name => 'my name', :child => child})
    parent.save
    found = Parent.find_one({:name => 'my name'}, {:raw => true})
    found.should == {:_id => parent.id, :name => 'my name', :child => {:name => 'child', :power => 88}}
  end
  it "finds a document by it's child" do
    child = Child.new({:name => 'child', :power => 88})
    parent = Parent.new({:name => 'my name', :child => child})
    parent.save
    Parent.count({'c.p' => 88}).should == 1
  end
end