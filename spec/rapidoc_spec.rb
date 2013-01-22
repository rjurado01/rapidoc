require 'rapidoc'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../dummy/config/environment", __FILE__)
require 'rspec/rails'

include Rapidoc
include Rapidoc::Config

describe Rapidoc do
  context "when create estructure" do
    before do
      create_structure
    end

    it "should create config files" do
      File.exists?( config_dir( "rapidoc.yml" ) ).should == true
    end

    it "should create target dir" do
      File.directory?( target_dir ).should == true
    end
  end

  context "when executing get_controller_info function" do

    before do
      @controller_info = get_controller_info
    end

    it "return correct resources" do
      @controller_info.keys.should be_include('images')
      @controller_info.keys.should be_include('albums')
      @controller_info.keys.should be_include('users')
    end

     it "return correct resource methods" do
      users_methods = @controller_info["users"].map{ |m| m[:method] }.uniq

      users_methods.should be_include( "GET" )
      users_methods.should be_include( "POST" )
      users_methods.should_not be_include( "PUT" )
      users_methods.should_not be_include( "DELETE" )
    end

    it "return correct resource actions" do
      users_actions = @controller_info["users"].map{ |m| m[:action] }

      users_actions.should be_include( "index" )
      users_actions.should be_include( "show" )
      users_actions.should be_include( "create" )
      users_actions.should_not be_include( "update" )
      users_actions.should_not be_include( "destroy" )
    end
  end

  context "when executing get_resources function" do
    before do
      @resources = get_resources
    end

    it "return correct resorces name" do
      names = @resources.map(&:name)
      names.should be_include( "images" )
      names.should be_include( "users" )
      names.should be_include( "albums" )
    end

    it "return correct controller_names" do
      names = @resources.map(&:controller_name)
      names.should be_include( "images_controller.rb" )
      names.should be_include( "users_controller.rb" )
      names.should be_include( "albums_controller.rb" )
    end

    it "return correct resource_methods" do
      resource_methods = @resources.last.resource_methods
      resource_methods.should ==  get_controller_info[ @resources.last.name ]
    end
  end

  context "when executing genarate_doc function" do
    before do	
      create_structure
      generate_doc( get_resources )
    end

    after do
      'rm -r #{::Rails.root.to_s} + "/rapidoc'
    end

    it "should create new index.html file" do
      File.exists?( ::Rails.root.to_s + "/rapidoc/index.html" ).should == true
    end
  end
end
