require 'bundler/setup'
require 'rack/file'
require 'capybara/rspec'
require 'spec_helper'

Capybara.app = Rack::File.new ::Rails.root.to_s

describe "Index page" do
  it "contains an H1 with text 'Resources'" do
    visit '/rapidoc/index.html'
    page.should have_css 'h1', :text => 'Resources'
  end
end
