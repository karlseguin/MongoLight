require 'spec_helper'

describe 'find behavior' do
  it "maps a document to a model" do
    id = Factory.create(:simple, {:name => 'paul', :power => 49}).id
    found = Simple.find_one({:name => 'paul'})
    found.name.should == 'paul'
    found.power.should == 49
    found.id.should == id
  end
  it "returns a model's raw data" do
    id = Factory.create(:simple, {:name => 'jessica', :power => 58}).id
    found = Simple.find_one({:power => 58}, {:raw => true})
    found[:name].should == 'jessica'
    found[:power].should == 58
    found[:_id].should == id
  end
  it "return nil if the doucment isn't found" do
    Simple.find_one({:blah => 'heh'}).should be_nil
  end
  it "maps multiple documents to a models" do
    id1 = Factory.create(:simple, {:name => 'duncan', :power => 3223}).id
    id2 = Factory.create(:simple, {:name => 'gurney', :power => 1033}).id
    found = Simple.find.to_a
    found.count.should == 2
    found[0].name.should == 'duncan'
    found[0].power.should == 3223
    found[0].id.should == id1
    found[1].name.should == 'gurney'
    found[1].power.should == 1033
    found[1].id.should == id2
  end
  it "returns a model's raw data" do
    id1 = Factory.create(:simple, {:name => 'duncan', :power => 3223}).id
    id2 = Factory.create(:simple, {:name => 'gurney', :power => 1033}).id
    found = Simple.find({}, {:raw => true}).to_a
    found.count.should == 2
    found[0].should == {:_id => id1, :name => 'duncan', :power => 3223}
    found[1].should == {:_id => id2, :name => 'gurney', :power => 1033}
  end
  it "return an empty array if nothing is found" do
    Simple.find({:blah => 'heh'}).to_a.count.should == 0
  end
  it "returns a document by id" do
    document = Factory.create(:simple)
    found = Simple.find_by_id(document.id)
    found.should == document
  end
  it "returns a document by string id" do
    document = Factory.create(:simple)
    found = Simple.find_by_id(document.id.to_s)
    found.should == document
  end
  it "returns nil if the document isn't found by id" do
    Simple.find_by_id(MongoLight::Id.new).should be_nil
  end
  
  it "counts the number of matching documents" do
    Factory.create(:simple)
    Factory.create(:simple)
    Factory.create(:simple, {:power => 'spice'})
    Simple.count.should == 3
    Simple.count({:power => 'spice'}).should == 1
  end
end