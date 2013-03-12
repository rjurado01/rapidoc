require 'spec_helper'

include Rapidoc

describe ParamErrors do
  context "when use default messages and descriptions"do
    context "when call get_required_error_info" do
      it "return correct error info" do
        info = get_required_error_info( 'name' )
        info['object'].should == 'name'
        info['message'].should == 'blank'
        info['description'].should == 'This parameter is mandatory'
      end
    end

    context "when call get_inclusion_error_info" do
      it "return correct error info" do
        info = get_inclusion_error_info( 'name' )
        info['object'].should == 'name'
        info['message'].should == 'inclusion'
        info['description'].should == 'This parameter is not in the collection'
      end
    end

    context "when call get_error_info" do
      it "return correct error info" do
        get_error_info( 'name', 'required' ).should == get_required_error_info( 'name' )
      end
    end
  end

  context "when use config messaes and descriptions" do
    before :all do

      File.open( config_file_path, 'w') do |file| 
        file.write "default_errors: true\n"
        file.write "errors:\n"
        file.write "  required:\n    message: \"m1\"\n    description: \"d1\"\n"
        file.write "  inclusion:\n    message: \"m2\"\n    description: \"d2\"\n"
      end

      load_config
    end

    context "when call get_required_error_info" do
      it "return correct error info" do
        info = get_required_error_info( 'name' )
        info['object'].should == 'name'
        info['message'].should == 'm1'
        info['description'].should == 'd1'
      end
    end

    context "when call get_inclusion_error_info" do
      it "return correct error info" do
        info = get_inclusion_error_info( 'name' )
        info['object'].should == 'name'
        info['message'].should == 'm2'
        info['description'].should == 'd2'
      end
    end

    context "when call get_error_info" do
      it "return correct error info" do
        get_error_info( 'name', 'required' ).should == get_required_error_info( 'name' )
      end
    end
  end
end
