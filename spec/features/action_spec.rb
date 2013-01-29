require 'bundler/setup'
require 'rack/file'
require 'capybara/rspec'
require 'spec_helper'

Capybara.app = Rack::File.new ::Rails.root.to_s

include Rapidoc

describe "Action page" do

  before :all do
    create_structure
    generate_doc get_resources
  end

  after :all do
    `rm -r #{ ::Rails.root.to_s + '/rapidoc' }`
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
end
