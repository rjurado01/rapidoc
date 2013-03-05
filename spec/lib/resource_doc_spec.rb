require 'spec_helper.rb'

include Rapidoc

describe ResourceDoc do
  context "when create new valid instance" do
    before do
      @resource_name = "users"
      @rdoc = ResourceDoc.new @resource_name, nil
    end

    it "should save it correctly" do
      @rdoc.name.should == @resource_name
    end
  end

  context "when check get_description function" do
    context "when extractor is valid and resource has description" do
      before do
        @extractor = ControllerExtractor.new "users_controller.rb"
        @rdoc = ResourceDoc.new "users", nil
      end

      it "return correct description" do
          description = @rdoc.send( :get_description, @extractor )
        description.should == @extractor.get_resource_info["description"]
      end
    end

    context "when extractor is valid and resource hasn't description" do
      before do
        @extractor = ControllerExtractor.new "users_controller.rb"
        @extractor.stub(:get_resource_info).and_return(false)
        @rdoc = ResourceDoc.new "users", nil
      end

      it "return not_found message" do
        description = @rdoc.send( :get_description, @extractor )
        description.should == "not_found"
      end
    end

    context "when extractor is invalid" do
      before do
        @extractor = nil
        @rdoc = ResourceDoc.new "invalid", nil
      end

      it "return not_controller message" do
        description = @rdoc.send( :get_description, @extractor )
        description.should == "not_controller"
      end
    end
  end

  context "when check get_actions_doc function" do
    before do
      @controller_extractor = ControllerExtractor.new "users_controller.rb"
      @actions_info = @controller_extractor.get_actions_info
      @rdoc = ResourceDoc.new "users", nil
    end

    it "should return ActionDoc array" do
      actions_doc = @rdoc.send( :get_actions_doc, @controller_extractor )
      actions_doc.class.should == Array
      actions_doc.each{ |ad| ad.class.should == ActionDoc }
    end
  end

  context "when check get_actions_urls" do
    before do
      @action = "index"
      @urls = [ '/url1', '/url2', '/url3', '/url4' ]
      routes_info = [ { :action => 'index', :resource => "users", :url => @urls[0] },
        { :action => 'index', :resource => "users", :url => @urls[1] },
        { :action => 'show', :resource => "users", :url => @urls[2] },
        { :action => 'index', :resource => "albums", :url => @urls[3] } ]

      @rdoc = ResourceDoc.new :users, routes_info
    end

    it "should return correct urls" do
      action_urls = @rdoc.send( :get_action_urls, @action )
      action_urls.should be_include( @urls[0] )
      action_urls.should be_include( @urls[1] )
      action_urls.should_not be_include( @urls[2] )
      action_urls.should_not be_include( @urls[3] )
    end
  end
end
