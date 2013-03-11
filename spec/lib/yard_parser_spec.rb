require "spec_helper"

include Rapidoc

describe Rapidoc::YamlParser do

  before :all do
    @description = "resource description"
    @action1 = "index"
    @action2 = "create"
    @blocks = [ { init: 0, end: 2 }, { init: 4, end: 6 }, { init: 8, end: 10 } ]
    @lines = [ 
      "  # =begin resource\n",
      "  # description: #{@description}\n",
      "  # =end\n",
      "  ...\n",
      "  # =begin action\n",
      "  # action: #{@action1}\n",
      "  # =end\n",
      "  ...\n",
      "  # =begin action\n",
      "  # action: #{@action2}\n",
      "  # =end\n" 
    ]
  end

  context "when call extract_resource_info" do
    before :all do
      @resource_info = extract_resource_info( @lines, @blocks )
    end

    it "returns resource info" do
      @resource_info.keys.should be_include( "description" )
    end

    it "return correct description" do
      @resource_info['description'].should == @description
    end
  end

  context "when call extract_actions_info" do
    before :all do
      @actions_info = extract_actions_info( @lines, @blocks )
    end

    it "returns all actions info" do
      @actions_info.size.should == 2
    end

    it "returns correct info of each action" do
      @actions_info.first['action'].should == @action1
      @actions_info.last['action'].should == @action2
    end
  end
end
