require "spec_helper"

include Rapidoc::Config

describe Rapidoc::Config do
  context "check get_route" do
    before do
      File.open("#{config_dir}/rapidoc.yml", 'w') { |file| file.write "route: \"vim\"" }
    end

    it "target_dir return correct dir" do
      target_dir().should eql( get_route )
    end

    it "target_dir return correct dir + file" do
      target_dir('file.html').should eql( get_route + '/file.html' )
    end
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

  context "when call get_route" do
    context "when config file has a route" do
      before do
        File.open("#{config_dir}/rapidoc.yml", 'w') { |file| file.write "route: \"vim\"" }
      end

      it "get_route return correct route" do
        get_route.should ==  ::Rails.root.to_s + "/vim"
      end
    end

    context "when config file hasn't a route" do
      before do
        File.open("#{config_dir}/rapidoc.yml", 'w') { |file| file.write "" }
      end

      it "get_route return incorrect route" do
        get_route.should == ::Rails.root.to_s + "/rapidoc"
      end
    end
  end

end
