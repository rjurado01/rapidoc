require "spec_helper"

include Rapidoc

describe Rapidoc do

  context "when is installing rapidoc" do
    before do
      create_config_structure
    end
    it { File.directory?("#{::Rails.root.to_s}/config/rapidoc").should be_true }
    it { File.directory?("#{::Rails.root.to_s}/config/rapidoc/examples").should be_true }
    it { File.exists?(config_dir("rapidoc.yml")).should be_true }
  end

  context "when is generating the doc" do
    context "with a default doc_routes" do
      before do
        create_doc_structure
        generate_doc
      end
      it { File.directory?("#{::Rails.root.to_s}/public/docs").should be_true }
      it { File.directory?("#{::Rails.root.to_s}/public/docs/actions").should be_true }
      it { File.directory?("#{::Rails.root.to_s}/public/docs/assets").should be_true }
      it { File.exists?("#{::Rails.root.to_s}/public/docs/index.html").should be_true }
    end
    context "with a diferent doc_route" do
      before do
        load_config
        @@config['doc_route'] = "api/v1"
        create_doc_structure
      end
      it { File.directory?("#{::Rails.root.to_s}/public/docs/api/v1").should be_true }
      # it { File.directory?("#{::Rails.root.to_s}/public/docs/actions").should be_true }
      # it { File.directory?("#{::Rails.root.to_s}/public/docs/assets").should be_true }
      # it { File.exists?("#{::Rails.root.to_s}/public/docs/index.html").should be_true }
    end
  end

  #context "when all is ok" do
    # before :all do
    #   create_structure
    #   load_config
    # end

    # after :all do
    #   remove_doc
    # end

    # context "when create target dir" do
    #     it { File.directory?("#{::Rails.root.to_s}/public/docs").should be_true }
    #   end

  #   context "when create estructure" do
  #     context "when create config files" do
  #       it { File.exists?(config_dir("rapidoc.yml")).should be_true }
  #     end

  #     context "when create example dir" do

  #     end
  #   end

  #   context "when executing genarate_doc function" do
  #     before do
  #       generate_doc
  #     end

  #     context "when create new index.html file" do
  #       context "with the doc_route by default" do
  #         it { File.exists?("#{::Rails.root.to_s}/public/docs/index.html" ).should == true }
  #       end
  #     end
  #   end
  # end

  # context "when there is an error" do
  #   before :all do
  #     create_structure

  #     File.open( config_file_path, 'w') { |file| file.write "controllers_route: \"public\"" }
  #     load_config

  #     controller = controller_dir 'users_controller.yml'
  #     File.open( controller, 'w' ) { |file|
  #       file.write "# =begin action\nhttp_status:\n  - 201\n  #params:\n  - name: 'name'\n# =end\n"
  #     }

  #     generate_doc
  #   end

  #   it "should return error" do
  #   end
  # end
end
