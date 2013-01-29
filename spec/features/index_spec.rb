require 'bundler/setup'
require 'rack/file'
require 'capybara/rspec'
require 'spec_helper'

Capybara.app = Rack::File.new ::Rails.root.to_s

include Rapidoc

describe "Index page" do

  before :all do
    create_structure
    generate_doc get_resources
  end

  before do
    visit '/rapidoc/index.html'
  end

  after :all do
    `rm -r #{ ::Rails.root.to_s + '/rapidoc' }`
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
    before :all do
      @resources = get_resources
    end

    it "contains the correct number of resources" do
      page.find(".accordion").should have_content "albums"
      page.find(".accordion").should have_content "images"
      page.find(".accordion").should have_content "users"
    end

    it "contains the correct methods" do
      @resources.each do |resource|
        resource.routes_info.each do |action|
          href = ( resource.name.to_s + "_" + action[:action] + ".html" ).to_s
          page.should have_link( action[:url], href: href )
        end
      end
    end

    it "contains the correct description" do
      @resources.each do |resource|
        page.should have_text(resource.description)
      end
    end
  end
end
