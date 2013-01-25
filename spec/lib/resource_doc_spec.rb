require 'spec_helper.rb'

include Rapidoc

describe ResourceDoc do
  context "when create new instance" do
    before do
      @resource_name = "users"
      resource_info = get_resources_info[ @resource_name ]
      @rdoc = ResourceDoc.new @resource_name, resource_info
    end

    it "should save it correctly" do
      @rdoc.name.should == @resource_name
      pp @rdoc.resource_actions
    end
  end
end
