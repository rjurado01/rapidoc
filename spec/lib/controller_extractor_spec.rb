require "spec_helper"

include Rapidoc

describe ControllerExtractor do
  context "when create instance with valid controller file" do

    before :all do
      @extractor = ControllerExtractor.new "users_controller.rb"
    end

    context "when extract actions info from a controller" do
      before :all do
        @info = @extractor.get_actions_info
      end

      it "should return info about all commented actions" do
        actions = @info.map{ |info| info["action"] }
        actions.should be_include( 'index' )
        actions.should be_include( 'show' )
        actions.should be_include( 'create' )
      end

      it "should return all mandatary fields" do
        info = @info.first

        info.keys.should be_include( 'http_responses' )
        info.keys.should be_include( 'action' )
        info.keys.should be_include( 'method' )
        info.keys.should be_include( 'requires_authentication' )
        info.keys.should be_include( 'response_formats' )
        info.keys.should be_include( 'description' )
      end
    end

    context "when check users index action information" do
      before :all do
        @info = @extractor.get_actions_info.select{ |a|  a["action"] == "index" }.first
      end

      it "should return all params" do
        params_name = @info["params"].map{ |p| p["name"] }
        params_name.should be_include( 'page' )
        params_name.should be_include( 'limit' )
        params_name.should be_include( 'name' )
      end

      it "should return all descriptions" do
        @info["params"].each{ |p| p.keys.should be_include( 'description' ) }
      end
    end

    context "when extract resource info from a controller" do
      before :all do
        @info = @extractor.get_resource_info
      end

      it "should return only info about resource" do
        @info.size.should == 1
      end

      it "should return info about resource" do
        @info.should be_include( 'description' )
      end
    end

    context "when extract controller info" do
      before :all do
        @info = @extractor.get_controller_info
      end

      it "return correct resource info" do
        @info["description"].should == @extractor.get_resource_info["description"]
      end

      it "return correct actions info" do
        @info["actions"].should == @extractor.get_actions_info
      end
    end
  end

  context "when create new instance with invalid controller file" do
    it "throw exception" do
      lambda{ ControllerExtractor.new( "no_file" ) }.should raise_error
    end
  end
end

