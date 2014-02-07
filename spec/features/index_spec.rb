require 'bundler/setup'
require 'rack/file'
require 'capybara/rspec'
require 'spec_helper'

Capybara.app = Rack::File.new ::Rails.root.to_s

include Rapidoc

describe "Index page" do

  before :all do
    reset_structure
    load_config
    @resources = get_resources
    generate_doc
  end

  before do
    visit '/rapidoc/index.html'
  end

  after :all do
    #remove_doc
  end

  context "when check global page" do
    it "contains an H1 with text 'Resources'" do
      page.should have_css 'h1', :text => 'Resources'
    end

    it "contains Title with text 'Project Name'" do
      page.should have_link('Project Name', '#')
    end
  end

  context "when check resources" do
    it "contains the correct number of resources" do
      page.find(".accordion").should have_content "albums"
      page.find(".accordion").should have_content "images"
      page.find(".accordion").should have_content "users"
    end

    it "contains the correct methods" do
      @resources.each do |resource|
        resource.actions_doc.each do |action|
          action.urls.each do |url|
            if action.has_controller_info
              page.should have_link( url, href: "actions/" + action.file.gsub('_','/') + ".html" )
            else
              page.should have_text( url )
            end
          end
        end
      end
    end

    it "contains the correct description" do
      @resources.each do |resource|
        resource.description.each do |paragraph|
          page.should have_text( paragraph )
        end
      end
    end
  end
end
