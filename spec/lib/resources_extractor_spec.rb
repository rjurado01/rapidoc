require "spec_helper"

include Rapidoc

describe Rapidoc::ResourcesExtractor do

  context "when executing get_routes_doc" do
    before :all do
      @routes_doc = get_routes_doc
    end

    it "returns RoutesDoc instance" do
      @routes_doc.class.should == RoutesDoc
    end

    it "instance include all resources" do
      resources_names = @routes_doc.get_resources_names
      resources_names.should be_include(:images)
      resources_names.should be_include(:albums)
      resources_names.should be_include(:users)
    end
  end

  context "when executing get_routes_doc and config has resources black list" do
    before :all do
      @routes_doc = get_routes_doc
    end

    it "returns RoutesDoc instance" do
      @routes_doc.class.should == RoutesDoc
    end

    it "instance include all resources" do
      resources_names = @routes_doc.get_resources_names
      resources_names.should be_include(:images)
      resources_names.should be_include(:albums)
      resources_names.should be_include(:users)
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
      names.should == [ "albums", "images", "testing", "users" ]
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

    context "when config has resources_black_list" do
      before do
        create_config_structure

        File.open("#{config_dir}/rapidoc.yml", 'w') do |file|
          file.write "resources_black_list: images, albums"
        end

        load_config
      end

      after :all do
        remove_config
      end

      it "returns correct resources names" do
        names = get_resources.map(&:name)
        names.should_not be_include( "images" )
        names.should_not be_include( "albums" )
        names.should be_include( "users" )
      end
    end
  end
end
