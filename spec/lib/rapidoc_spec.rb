require "spec_helper"

include Rapidoc

describe Rapidoc do

  before :all do
    create_structure
  end

  after :all do
    remove_doc
  end

  context "when create estructure" do
    it "should create config files" do
      File.exists?( config_dir( "rapidoc.yml" ) ).should == true
    end

    it "should create target dir" do
      File.directory?( target_dir ).should == true
    end

    it "should create example dir" do
      File.directory?( get_examples_dir ).should == true
    end
  end

  context "when executing genarate_doc function" do
    before do
      generate_doc( get_resources )
    end

    it "should create new index.html file" do
      File.exists?( ::Rails.root.to_s + "/rapidoc/index.html" ).should == true
    end
  end
end
