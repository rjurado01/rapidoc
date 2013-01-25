require 'spec_helper.rb'

include Rapidoc

describe ActionDoc do
  context "when initialize ActionDoc" do
    before do
      extractor = ControllerExtractor.new "users_controller.rb"
      @info = extractor.get_actions_info.first
      @action_doc = ActionDoc.new @info
    end

    it "should save correct values" do
      @action_doc.action.should == @info["action"]
    end
  end
end
