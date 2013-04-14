require "spec_helper"

include Rapidoc

describe ControllerExtractor do

  context "when create instance with valid controller file" do
    before :all do
      @extractor = ControllerExtractor.new "users_controller.rb"
    end

    context

    context "when call get_actions_info function" do
      before :all do
        @info = @extractor.get_actions_info
      end

      it "should return info about all commented actions" do
        actions = @info.map{ |info| info["action"] }
        actions.should be_include( 'index' )
        actions.should be_include( 'show' )
        actions.should be_include( 'create' )
      end
    end

    context "when call get_action_info " do
      before :all do
        @info = @extractor.get_action_info( "index" )
      end

      it "returns the correct action" do
        @info['action'].should == "index"
      end

      it "should return all mandatary fields" do
        @info.keys.should be_include( 'http_responses' )
        @info.keys.should be_include( 'action' )
        @info.keys.should be_include( 'method' )
        @info.keys.should be_include( 'authentication_required' )
        @info.keys.should be_include( 'response_formats' )
        @info.keys.should be_include( 'description' )
      end
    end

    context "when call get_resource_info" do
      before :all do
        @info = @extractor.get_resource_info
      end

      it "controller info contatins resource description" do
        @info.keys.should be_include( 'description' )
      end
    end

    context "when call get_controller_info" do
      before :all do
        @info = @extractor.get_controller_info
      end

      it "returns resource description" do
        @info.keys.should be_include( 'description' )
      end

      it "returns resource actions info" do
        @info.keys.should be_include( 'actions' )
      end
    end
  end

  context "when create new instance with invalid controller file" do
    it "throw exception" do
      lambda{ ControllerExtractor.new( "no_file" ) }.should raise_error
    end
  end

  context "when check controllers_name" do
    context "when use default controllers route" do
      it "use .rb extension for controllers files" do
        ResourceDoc.any_instance.stub( :generate_info ).and_return( true )
        resource_doc = ResourceDoc.new( 'user', nil )
        resource_doc.controller_file.should == "users_controller.rb"
      end
    end

    context "when use custom controllers route" do
      it "use .yml extension for controllers files" do
        File.open( config_file_path, 'w') { |file| file.write "controllers_route: \"vim\"" }
        load_config

        ResourceDoc.any_instance.stub( :generate_info ).and_return( true )
        resource_doc = ResourceDoc.new( 'user', nil )
        resource_doc.controller_file.should == "users_controller.yml"
      end
    end
  end
end

