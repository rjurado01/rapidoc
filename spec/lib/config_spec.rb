require "spec_helper"

include Rapidoc

describe Rapidoc::Config do
  before :all do
    reset_structure
  end

  after :all do
    remove_structure
  end

  it "config_dir returns correct dir" do
    config_dir().should eql( ::Rails.root.to_s + '/config/rapidoc' )
  end

  it "config_dir returns correct dir + file" do
    config_dir('file.yml').should eql( ::Rails.root.to_s + '/config/rapidoc/file.yml' )
  end

  it "gem_templates_dir returns correct dir" do
    gem_templates_dir().should =~ /(.*)\/lib\/rapidoc\/templates/
  end

  it "gem_templates_dir returns correct dir + file" do
    gem_templates_dir('template.hbs').should  =~ /(.*)\/templates\/template\.hbs/
  end

  context "when call trace?" do
    it "returns false with default options" do
      trace?.should == false
    end

    it "returns true when config has trace=true" do
      File.open( config_file_path, 'w') { |file| file.write "trace: true" }
      load_config
      trace?.should == true
    end
  end

  context "when call controller_dir" do
    context "when use default route" do
      it "controller_dir returns correct dir" do
        controller_dir().should eql( ::Rails.root.to_s + '/app/controllers' )
      end

      it "controller_dir returns correct dir + file" do
        controller_dir('file.rb').should eql( ::Rails.root.to_s + '/app/controllers/file.rb' )
      end
    end

    context "when use config route" do
      it "controller_dir returns correct dir" do
        File.open( config_file_path, 'w') { |file| file.write "controllers_route: \"vim\"" }
        load_config
        controller_dir().should eq("#{::Rails.root}/vim" )
      end
    end
  end

  context "when call target_dir" do
    context "when config file has a route" do
      before do
        File.open( config_file_path, 'w') { |file| file.write "doc_route: \"vim\"" }
        load_config
      end

      it "returns correct route" do
        target_dir.should eq("#{::Rails.root.to_s}/public/docs/vim")
      end
    end

    context "when config file hasn't a route" do
      before do
        File.open("#{config_dir}/rapidoc.yml", 'w') { |file| file.write "" }
        load_config
      end

      it "returns default route" do
        target_dir.should  eq("#{::Rails.root}/public/docs")
      end
    end

    context "when pass file name" do
      it "returns correct dir + file" do
        target_dir('file.html').should eql( target_dir + '/file.html' )
      end
    end
  end

  context "when call default_errors" do
    before :all do
      File.open( config_file_path, 'w') { |file| file.write "default_errors: true" }
      load_config
    end

    context "when action is index" do
      it "returns false" do
        default_errors?( 'index' ).should == false
      end
    end

    context "when action is create" do
      it "returns true" do
        default_errors?( 'create' ).should == true
      end
    end
  end

  context "when call default_response_formats" do
    context "when config file has not response_formats" do
      it "returns nil" do
        default_response_formats.should == nil
      end
    end

    context "when config file has response_formats" do
      it "returns response formats" do
        File.open( config_file_path, 'w') { |file| file.write "response_formats: json" }
        load_config
        default_response_formats.should == 'json'
      end
    end
  end

  context "when call actions_dir" do
    context "when config file has a route" do
      before do
        File.open( config_file_path, 'w') { |file| file.write "doc_route: \"vim\"" }
        load_config
      end

      it "returns correct route" do
        actions_dir.should eq("#{::Rails.root}/public/docs/vim/actions")
      end
    end

    context "when config file hasn't a route" do
      before do
        File.open("#{config_dir}/rapidoc.yml", 'w') { |file| file.write "" }
        load_config
      end

      it "returns default route" do
        actions_dir.should eq("#{::Rails.root.to_s}/public/docs/actions")
      end
    end

    context "when pass file name" do
      it "returns correct dir + file" do
        actions_dir('file.html').should eql( actions_dir + '/file.html' )
      end
    end
  end

  context "when call examples_dir" do
    context "when config file has an example dir" do
      before do
        File.open( "#{config_dir}/rapidoc.yml", 'w' ) do |file|
          file.write "examples_route: \"vim\""
        end

        load_config
      end

      it "examples_dir returns correct route" do
        examples_dir.should == ::Rails.root.to_s + "/vim"
      end
    end
    context "when config file hasn't an example dir" do
      before do
        File.open("#{config_dir}/rapidoc.yml", 'w') { |file| file.write "" }
        load_config
      end

      it "examples_dir returns default examples dir route" do
        examples_dir.should == "#{config_dir}/examples"
      end
    end
  end

  context "when call resources_black_list" do
    context "when config file has resources_black_list" do
      it "returns array with resources" do
        File.open("#{config_dir}/rapidoc.yml", 'w') do |file|
          file.write "resources_black_list: images, albums"
        end
        load_config
        resources_black_list.should == [ :images, :albums ]
      end
    end

    context "when config file has not resources_black_list" do
      it "returns empty array" do
        File.open("#{config_dir}/rapidoc.yml", 'w') { |file| file.write "" }
        load_config
        resources_black_list.should == []
      end
    end
  end
end
