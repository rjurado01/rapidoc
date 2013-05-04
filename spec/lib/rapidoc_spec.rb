require "spec_helper"

include Rapidoc

describe Rapidoc do

  context "when all is ok" do
    before :all do
      create_structure
      load_config
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
        File.directory?( examples_dir ).should == true
      end
    end

    context "when executing genarate_doc function" do
      before do
        generate_doc
      end

      it "should create new index.html file" do
        File.exists?( ::Rails.root.to_s + "/rapidoc/index.html" ).should == true
      end
    end
  end

  context "when there is an error" do
    before :all do
      create_structure

      File.open( config_file_path, 'w') { |file| file.write "controllers_route: \"public\"" }
      load_config

      controller = controller_dir 'users_controller.yml'
      File.open( controller, 'w' ) { |file|
        file.write "# =begin action\nhttp_status:\n  - 201\n  #params:\n  - name: 'name'\n# =end\n"
      }

      generate_doc
    end

    it "should return error" do
    end
  end
end
