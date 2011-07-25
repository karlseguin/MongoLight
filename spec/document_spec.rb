require 'spec_helper'

describe MongoLight::Document do
  it "loads the attributes from a hash" do
    s = Simple.new({:name => 'goku', :power => 9001})
    s.name.should == 'goku'
    s.power.should == 9001
  end
  
  it "generates an id" do
    MongoLight::Id.stub!(:new).and_return('i will not fear')
    Simple.new.id.should == 'i will not fear'
  end
  
  it "creates writable properties" do
    s = Simple.new
    s.name = 'ghanima'
    s.power = 23
    s.name.should == 'ghanima'
    s.power.should == 23
  end
  
  it "returns the properties as a hash" do
    MongoLight::Id.stub!(:new).and_return(3)
    s = Simple.new({:name => 'paul', :power => 'spice' })
    s.attributes.should == {:name => 'paul', :power => 'spice', :_id => 3}
  end
  
  it "considers items with the same ids as equals" do
    Simple.new({:id => 3}).should == Simple.new({:id => 3})
  end
  
  it "considers items with differnet same ids as not equals" do
    Simple.new({:id => 4}).should_not == Simple.new({:id => 3})
  end

end