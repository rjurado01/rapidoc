require "spec_helper"

include Rapidoc

describe Rapidoc do
  context "when is installing rapidoc" do
    before do
      create_config_structure
    end
    it { File.directory?("#{::Rails.root}/config/rapidoc").should be_true }
    it { File.directory?("#{::Rails.root}/config/rapidoc/examples").should be_true }
    it { File.exists?(config_dir("rapidoc.yml")).should be_true }
  end

  context "when is generating the doc" do
    context "with a default doc_routes" do
      before do
        create_doc_structure
        generate_doc
      end
      after :all do
        remove_doc
      end
      it { File.directory?("#{::Rails.root}/public/docs").should be_true }
      it { File.directory?("#{::Rails.root}/public/docs/actions").should be_true }
      it { File.directory?("#{::Rails.root}/public/docs/assets").should be_true }
      it { File.exists?("#{::Rails.root}/public/docs/index.html").should be_true }
    end
    context "with a diferent doc_route" do
      before do
        File.open( config_file_path, 'w') { |file| file.write "doc_route: api/v1" }
        load_config
        create_doc_structure
        generate_doc
      end
      after :all do
        remove_doc
      end
      it { File.directory?("#{::Rails.root.to_s}/public/docs/api/v1").should be_true }
      it { File.directory?("#{::Rails.root.to_s}/public/docs/api/v1/actions").should be_true }
      it { File.directory?("#{::Rails.root.to_s}/public/docs/api/v1/assets").should be_true }
      it { File.exists?("#{::Rails.root.to_s}/public/docs/api/v1/index.html").should be_true }
    end
  end
  after :all do
    remove_structure
  end
end
