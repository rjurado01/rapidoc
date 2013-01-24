require "spec_helper"

include Rapidoc::Config

describe Rapidoc::Config do
  it "target_dir return correct dir" do
    target_dir().should eql( ::Rails.root.to_s + '/rapidoc' )
  end

  it "target_dir return correct dir + file" do
    target_dir('file.html').should eql( ::Rails.root.to_s + '/rapidoc/file.html' )
  end

  it "config_dir return correct dir" do
    config_dir().should eql( ::Rails.root.to_s + '/config/rapidoc' )
  end

  it "config_dir return correct dir + file" do
    config_dir('file.yml').should eql( ::Rails.root.to_s + '/config/rapidoc/file.yml' )
  end

  it "controller_dir return correct dir" do
    controller_dir().should eql( ::Rails.root.to_s + '/app/controllers' )
  end

  it "controller_dir return correct dir + file" do
    controller_dir('file.rb').should eql( ::Rails.root.to_s + '/app/controllers/file.rb' )
  end

  it "gem_templates_dir return correct dir" do
    gem_templates_dir().should =~ /(.*)\/lib\/rapidoc\/templates/
  end

  it "gem_templates_dir return correct dir + file" do
    gem_templates_dir('template.hbs').should  =~ /(.*)\/templates\/template\.hbs/
  end
end
