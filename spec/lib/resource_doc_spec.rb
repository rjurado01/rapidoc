require 'spec_helper.rb'

include Rapidoc

describe ResourceDoc do
  context "when create new valid instance" do
    before do
      @resource_name = "users"
      @resource_info = get_resources_info[ @resource_name ]
      @rdoc = ResourceDoc.new @resource_name, @resource_info
    end

    it "should save it correctly" do
      @rdoc.name.should == @resource_name
    end
  end

  context "when create new instance with invalid controller" do
    before do
      @resource_info = get_resources_info[ "users" ]
      @rdoc = ResourceDoc.new "no_found", @resource_info
    end

    it "return [] when call get_actions" do
      @rdoc.get_actions( @resource_info ).should == []
    end
  end
end
