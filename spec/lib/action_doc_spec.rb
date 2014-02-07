require 'spec_helper.rb'

include Rapidoc

describe ActionDoc do

  before :all do
    @json_info =  { "user" => { "name" => "Check", "apellido" => "Me" } }
    response_file = examples_dir "users/create_response.json"
    answer_file = examples_dir "users/create_request.json"

    reset_structure
    create_folders_for_files([response_file, answer_file])
    File.open( response_file, 'w') { |file| file.write @json_info.to_json }
    File.open( answer_file, 'w') { |file| file.write @json_info.to_json }

    @info = {
      :resource=>"users",
      :action=>"create",
      :method=>"POST",
      :urls=>["/users(.:format)"]
    }

    extractor = ControllerExtractor.new "users_controller.rb"
    @controller_info = extractor.get_action_info( 'create' )
  end

  after :all do
    remove_examples
  end

  context "when initialize ActionDoc" do
    before :all do
      @action_doc = ActionDoc.new( @info, @controller_info, examples_dir )
    end

    it "set correct action info" do
      @action_doc.action.should == @info[:action]
    end

    it "set correct resource" do
      @action_doc.resource.should == @info[:resource]
    end

    it "set correct urls" do
      @action_doc.urls.should == @info[:urls]
    end

    it "set correct action method" do
      @action_doc.action_method.should == @info[:method]
    end

    it "set correct description" do
      @action_doc.description.should == @controller_info["description"]
    end

    it "set correct http responses" do
      http_responses = @action_doc.send( :get_http_responses,
                                        @controller_info["http_responses"] )
    end

    it "set correct requires authentication" do
      @action_doc.authentication.should == false
    end

    it "set correct file" do
      @action_doc.file.should == @info[:resource].to_s + "/" + @info[:action].to_s
    end

    it "set correct example_req" do
      @action_doc.example_res.should == JSON.pretty_generate( @json_info )
    end

    it "set correct example_res" do
      @action_doc.example_req.should == JSON.pretty_generate( @json_info )
    end

    context "when executing get_http_responses method" do
      before do
        @codes = [ 200, 401 ]
        @http_responses = @action_doc.send( :get_http_responses, @codes )
      end

      it "return new HttpResponse Array" do
        @http_responses.each do |r|
          r.class.should == HttpResponse
        end
      end

      it "each HttpResponse element should include correct code" do
        @http_responses.each_index do |i|
          @http_responses[i].code.should == @codes[i]
        end
      end

      it "each HttpResponse element should include description" do
        @http_responses.each{ |http_r| http_r.methods.should be_include( :description ) }
      end

      it "each HttpResponse element should include label" do
        @http_responses.each{ |http_r| http_r.methods.should be_include( :label ) }
      end
    end

    context "when checking errors" do
      context "when action has custom errors" do
        before :all do
          @errors = @action_doc.errors
        end

        it "return all errors" do
          @errors.size.should == 1
        end

        it "return password errors" do
          params_errors = @errors.select{ |error| error["object"] == 'password' }
          messages = params_errors.map{ |m| m["message"] }
          messages.should be_include( 'too_short' )
        end
      end
    end

    context "when call get_authentication function" do
      context "when pass true/false" do
        it "return correctly value" do
          @action_doc.send( :get_authentication, false ).should == false
          @action_doc.send( :get_authentication, true ).should == true
        end
      end
      context "when pass nil" do
        it "return correctly default value (true)" do
          @action_doc.send( :get_authentication, nil ).should == true
        end
      end
    end
  end

  context "when default response formats are actived" do
    before :all do
      File.open("#{config_dir}/rapidoc.yml", 'w') do |file|
        file.write "response_formats: xml"
      end

      load_config
      @action_doc = ActionDoc.new( @info, @controller_info, examples_dir )
    end

    it "returns default response formats" do
      @action_doc.response_formats.should == 'xml'
    end
  end

  context "when default errors are actived" do
    context "when use default messages and descriptions" do
      before :all do
        File.open("#{config_dir}/rapidoc.yml", 'w') do |file|
          file.write "default_errors: true"
        end

        load_config
        action_doc = ActionDoc.new( @info, @controller_info, examples_dir )
        @errors = action_doc.errors
      end

      it "return all errors" do
        @errors.size.should == 6
      end

      it "returns correct messages" do
        messages = @errors.map{ |error| error["message"] }
        messages.should be_include( 'blank' )
        messages.should be_include( 'too_short' )
        messages.should be_include( 'inclusion' )
      end
    end

    context "when use config messages and descriptions" do
      before :all do
        File.open( config_file_path, 'w') do |file|
          file.write "default_errors: true\n"
          file.write "errors:\n"
          file.write "  required:\n    message: \"m1\"\n    description: \"d1\"\n"
          file.write "  inclusion:\n    message: \"m2\"\n    description: \"d2\"\n"
        end

        load_config
        action_doc = ActionDoc.new( @info, @controller_info, examples_dir )
        @errors = action_doc.errors
      end

      it "return all errors" do
        @errors.size.should == 6
      end

      it "returns correct messages" do
        messages = @errors.map{ |error| error["message"] }
        messages.should be_include( 'm1' )
        messages.should be_include( 'too_short' )
        messages.should be_include( 'm2' )
      end
    end
  end
end
