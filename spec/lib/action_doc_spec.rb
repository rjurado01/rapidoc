require 'spec_helper.rb'

include Rapidoc

describe ActionDoc do

  context "" do
    before :all do
      create_structure
      extractor = ControllerExtractor.new "users_controller.rb"
      @resource = :users
      @urls = [ "/url1", "/url2" ]
      @info = extractor.get_actions_info.first
      @examples_route = get_examples_dir
      @action_doc = ActionDoc.new @resource, @info, @urls, @examples_route
    end

    context "when initialize ActionDoc" do

      it "should set correct action info" do
        @action_doc.action.should == @info["action"]
      end

      it "should set correct resource" do
        @action_doc.resource.should == @resource
      end

      it "should set correct urls" do
        @action_doc.urls.should == @urls
      end

      it "should set correct action method" do
        @action_doc.action_method.should == @info["method"]
      end

      it "should set correct description" do
        @action_doc.description.should == @info["description"]
      end

      it "should set correct example_route" do
        @action_doc.examples_route.should == @examples_route
      end

      it "should set correct http responses" do
        http_responses = @action_doc.get_http_responses( @info["http_responses"] )

        @action_doc.http_responses.each_index do |i|
          @action_doc.http_responses[i].code.should == http_responses[i].code
          @action_doc.http_responses[i].description.should == http_responses[i].description
          @action_doc.http_responses[i].label.should == http_responses[i].label
        end
      end

      it "should set correct file" do
        @action_doc.file.should == @resource.to_s + "_" + @info["action"].to_s
      end
    end

    context "when executing get_http_responses method" do
      before do
        @codes = [ 200, 401 ]
        @http_responses = @action_doc.get_http_responses @codes
      end

      it "should return new HttpResponse Array" do
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
  end

  context "when use examples config dir" do

    before do
      create_structure
      extractor = ControllerExtractor.new "users_controller.rb"
      @resource = :users
      @urls = [ "/url1", "/url2" ]
      @info = extractor.get_actions_info.first
      @examples_route = get_examples_dir

      @json_info =  { "user" => { "name" => "Antonio", "apellido" => "Jimenez" } }.to_json
      File.open("#{config_dir}/examples/users_#{@info["action"]}_response.yml", 'w') { |file|
        file.write "#{@json_info}" }
      File.open("#{config_dir}/examples/users_#{@info["action"]}_request.yml", 'w') { |file|
        file.write "#{@json_info}" }

      @action_doc = ActionDoc.new @resource, @info, @urls, @examples_route
    end

    it "should set correct example_req" do
      @action_doc.example_res.should == @json_info
    end

    it "should set correct example_res" do
      @action_doc.example_req.should == @json_info
    end


=begin
    context "when call load_examples" do
      before do
        @action_doc.example_route = ""
        @ation_doc.load_examples
      end

      it "should be empty example_req" do
        @action_doc.example_req.should == ""
      end

      it "should be empty example_res" do
        @action_doc.example_res.should == ""
      end
    end
=end
  end
end
