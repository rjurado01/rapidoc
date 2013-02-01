require 'bundler/setup'
require 'rack/file'
require 'capybara/rspec'
require 'spec_helper'
require 'rspec/rails'

Capybara.app = Rack::File.new ::Rails.root.to_s

include Rapidoc


describe "Action page"  do
  context "when check action page" do
    before :all do
      reset_structure
      generate_doc get_resources
    end

    after :all do
      `rm -r #{ target_dir }`
    end

    before do
      visit '/rapidoc/users_index.html'
      @user_resource = get_resources.select{ |r| r.name == :users }.first
    end

    context "when check action page" do
      it "contains title with text 'Project'" do
        config = YAML.load( File.read("#{config_dir}/rapidoc.yml") )
        page.should have_link( config["project_name"], '#' )
      end

      it "contains an H1 with text 'user'" do
        page.should have_css 'h1', :text => @user_resource.name.to_s
      end
    end

    context "when check tab 'Home'" do
      before do
        @action_info = @user_resource.actions_doc.first
      end

      it "contains a description of the resource" do
        page.should have_text(@action_info.description)
      end

      it "contains the resource URL" do
        page.should have_text(@action_info.urls.first)
      end

      it "contains the correct states" do
        @action_info.http_responses do |http_response|
          page.should have_content("td", http_response.description)
        end
      end
    end

    context "when check the answer from the server", :type => :request do
      it "answer contains the correct response" do
        get '/users'
        correct_answer = { "name" => "Antonio", "apellido" => "Jimenez" }
        response.body.should == correct_answer.to_json
      end
    end
  end

  context "when check 'request' and 'response' tabs" do
    before :all do
      reset_structure
      extractor = ControllerExtractor.new "users_controller.rb"
      @info = extractor.get_actions_info.first
      @json_info =  { "user" => { "name" => "Antonio", "apellido" => "Jimenez" } }
    end

    after :all do
      `rm -r #{ get_examples_dir }`
    end

    context "when check 'request' tab" do
      before do
        File.open("#{config_dir}/examples/users_#{@info["action"]}_request.yml", 'w') { |file|
          file.write "#{@json_info.to_json}" }
        generate_doc get_resources
        visit '/rapidoc/users_index.html'
        @user_resource = get_resources.select{ |r| r.name == :users }.first
      end

      it "should contain the correct request" do
        page.should have_text(@user_resource.actions_doc.first.example_req)
      end
    end

    context "when check 'response' tab" do
      before do
        File.open("#{config_dir}/examples/users_#{@info["action"]}_response.yml", 'w') { |file|
          file.write "#{@json_info.to_json}" }
        generate_doc get_resources
        visit '/rapidoc/users_index.html'
        @user_resource = get_resources.select{ |r| r.name == :users }.first
      end

      it "should contain the correct response" do
        page.should have_text(@user_resource.actions_doc.first.example_res)
      end
    end
  end
end
