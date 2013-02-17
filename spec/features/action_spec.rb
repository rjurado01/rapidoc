require 'bundler/setup'
require 'rack/file'
require 'capybara/rspec'
require 'spec_helper'

Capybara.app = Rack::File.new ::Rails.root.to_s

include Rapidoc

describe "Action page" do

  before :all do
    reset_structure
    generate_doc get_resources
    @user_resource = get_resources.select{ |r| r.name == "users" }.first
  end

  after :all do
    `rm -r #{ target_dir }`
  end

  context "when visit users_index.html page" do
    before do
      visit '/rapidoc/users_index.html'
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

      it "contains action name" do
        page.should have_css("td", @action_info.action)
      end

      it "contains action method" do
        page.should have_css("td", @action_info.action_method)
      end

      it "contains action response formats" do
        page.should have_css("td", @action_info.response_formats)
      end

      it "contains icon that show if action requires authentication" do
        if @action_info.authentication == true
          page.should have_css("i.icon-ok")
        else
          page.should have_css("i.icon-remove")
        end
      end

      it "contains the resource URL" do
        page.should have_text(@action_info.urls.first)
      end

      it "contains the correct states" do
        @action_info.http_responses.each do |http_response|
          page.should have_css("td", http_response.description)
        end
      end
    end

    context "when check tab 'Params'" do
      before do
        @params_info = @user_resource.actions_doc.first.params
      end

      it "have table with one row for each parameter" do
        page.should have_css( "table#table-params tr", :count => @params_info.size )
      end

      it "have a row with parameter name" do
        @params_info.each do |param|
          page.should have_css( "table#table-params td", :text => /#{param["name"]}.*/ )
        end
      end

      it "have a row with parameter type" do
        @params_info.each do |param|
          if param.keys.include? "type"
            page.should have_css( "table#table-params td", :text => /.*#{param["type"]}/ )
          end
        end
      end

      it "have a row with parameter description" do
        @params_info.each do |param|
          page.should have_css( "table#table-params td", :text => param["description"] )
        end
      end

      it "have a row with parameter type" do
        @params_info.each do |param|
          page.should have_css( "table#table-params td", :text => param["type"] )
        end
      end
    end
  end

  context "when visit users_create.html page" do
    before do
      visit '/rapidoc/users_create.html'
    end

    context "when check params tab" do
      before do
        @create_params_info = @user_resource.actions_doc.last.params
      end

      it "have a row with parameter type or inclusion" do
        @create_params_info.each do |param|
          if param["inclusion"]
            page.should have_css( "table#table-params td", :text => param["inclusion"] )
          else
            page.should have_css( "table#table-params td", :text => param["type"] )
          end
        end
      end
    end

    context "when check errors tab" do
      before do
        action_doc = @user_resource.actions_doc.select{ |ad| ad.action == "create" }.first
        @errors = action_doc.errors
      end

      it "have table with one row for each error" do
        header = 1
        page.should have_css( "table#table-errors tr", :count => @errors.size + header )
      end

      it "have a col with error object" do
        @errors.each do |error|
          page.should have_css( "table#table-errors td", :text => /#{error["object"]}.*/ )
        end
      end

      it "have a col with error message" do
        @errors.each do |error|
          page.should have_css( "table#table-errors td", :text => /#{error["message"]}.*/ )
        end
      end

      it "have a col with error description" do
        @errors.each do |error|
          page.should have_css( "table#table-errors td", :text => /#{error["description"]}.*/ )
        end
      end

      it "have a row with error message" do
        @errors.each do |error|
          page.should have_css( "table#table-errors tr",
            :text => /#{error["object"]}.#{error["message"]}.*#{error["description"]}/ )
        end
      end
    end
  end
end
