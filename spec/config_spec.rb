require 'rapidoc'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../dummy/config/environment", __FILE__)
require 'rspec/rails'

include Rapidoc::Config

describe Rapidoc::Config do
  it "target_dir return correct dir" do
    target_dir().should eql( ::Rails.root.to_s + '/rapidoc/' )
  end

  it "target_dir return correct dir + file" do
    target_dir('file.html').should eql( ::Rails.root.to_s + '/rapidoc/file.html' )
  end
end
