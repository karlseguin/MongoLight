require 'spec_helper'

describe 'duplicate behavior' do
  before(:each) do
    Simple.collection.create_index([['name', Mongo::ASCENDING]], {:unique => true})
  end
  after(:each) do
    Simple.collection.drop_index('name_1')
  end
  
  it "is flags a duplicate exception" do
    FactoryGirl.create(:simple, {:name => 'leto'})
    begin
      FactoryGirl.build(:simple, {:name => 'leto'}).save!
      false.should be_true
    rescue Mongo::OperationFailure
     $!.duplicate?.should be_true
     $!.duplicate_on?(:name).should be_true
     $!.duplicate_on?('name').should be_true
    end
  end
end