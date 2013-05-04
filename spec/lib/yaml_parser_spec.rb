require "spec_helper"

include Rapidoc

def capture_stdout(&block)
  original_stdout = $stdout
  $stdout = fake = StringIO.new
  begin
    yield
  ensure
    $stdout = original_stdout
  end
  fake.string
end

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
    context "when block is correct" do
      before :all do
        @resource_info = extract_resource_info( @lines, @blocks, 'file' )
      end

      it "returns resource info" do
        @resource_info.keys.should be_include( "description" )
      end

      it "return correct description" do
        @resource_info['description'].should == @description
      end
    end

    context "when there is an error in a description" do
      before :all do
        @blocks2 = [ { init: 0, end: 2 } ]
        @lines2 = [
          "  # =begin resource\n",
          "  # description: hello : goodbye\n",
          "  # =end\n"
        ]
      end

      it "prints error message" do
        output = capture_stdout { extract_resource_info( @lines2, @blocks2, 'file' ) }
        output.should == "Error parsing block in file file [0 - 2]\n"
      end
    end
  end

  context "when call extract_actions_info" do
    context "when block is correct" do
      before :all do
        @actions_info = extract_actions_info( @lines, @blocks, 'file' )
      end

      it "returns all actions info" do
        @actions_info.size.should == 2
      end

      it "returns correct info of each action" do
        @actions_info.first['action'].should == @action1
        @actions_info.last['action'].should == @action2
      end
    end

    context "when there is an error in the block" do
      before :all do
        @blocks2 = [ { init: 0, end: 2 } ]
        @lines2 = [
          "  # =begin action\n",
          "  # action: hello : goodbye\n",
          "  # =end\n"
        ]
      end

      it "prints error message" do
        output = capture_stdout { extract_actions_info( @lines2, @blocks2, 'file' ) }
        output.should == "Error parsing block in file file [0 - 2]\n"
      end
    end
  end
end
