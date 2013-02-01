require "spec_helper"

include Rapidoc

describe Rapidoc::ResourcesExtractor do

  context "when executing get_resources_info function" do
    before :all do
      @resources_info = get_resources_info
    end

    it "return correct resources" do
      @resources_info.keys.should be_include(:images)
      @resources_info.keys.should be_include(:albums)
      @resources_info.keys.should be_include(:users)
    end

     it "return correct resource methods" do
      users_methods = @resources_info[:users].map{ |m| m[:method] }.uniq

      users_methods.should be_include( "GET" )
      users_methods.should be_include( "POST" )
      users_methods.should_not be_include( "PUT" )
      users_methods.should_not be_include( "DELETE" )
    end

    it "return correct resource actions" do
      users_actions = @resources_info[:users].map{ |m| m[:action] }

      users_actions.should be_include( "index" )
      users_actions.should be_include( "show" )
      users_actions.should be_include( "create" )
      users_actions.should_not be_include( "update" )
      users_actions.should_not be_include( "destroy" )
    end
  end

  context "when executing get_resources function" do
    before :all do
      @resources = get_resources
    end

    it "return correct resorces name" do
      names = @resources.map(&:name)
      names.should be_include( "images" )
      names.should be_include( "users" )
      names.should be_include( "albums" )
    end

    it "return correct controller_names" do
      files = @resources.map(&:controller_file)
      files.should be_include( "images_controller.rb" )
      files.should be_include( "users_controller.rb" )
      files.should be_include( "albums_controller.rb" )
    end

    it "return correct resource actions" do
      @user_resource = @resources.select{ |r| r.name == "users" }.first
      actions = @user_resource.actions_doc.map{ |r| r.action }

      actions.should be_include( 'index' )
      actions.should be_include( 'show' )
      actions.should be_include( 'create' )
    end

    it "return correct order" do
      names = @resources.map(&:name)
      names.should == [ "albums", "images", "users" ]
    end

    context "when check resource with controller" do
      before do
        @user_resource = @resources.select{ |r| r.name == "users" }.first
      end

      it "return correct info about controller actions" do
        actions = @user_resource.actions_doc.map{ |r| r.action }
        actions.should be_include( 'index' )
        actions.should be_include( 'show' )
        actions.should be_include( 'create' )
      end
    end
  end
end
