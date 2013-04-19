require 'spec_helper.rb'

include Rapidoc

describe ResourceDoc do
  before :all do
    @extractor = ControllerExtractor.new "users_controller.rb"
    @routes_actions_info = get_routes_doc.get_actions_route_info( :users )
  end

  context "when create new valid instance only with resource name" do
    before do
      @resource_name = "users"
      @rdoc = ResourceDoc.new @resource_name, nil
    end

    it "saves it correctly" do
      @rdoc.name.should == @resource_name
      @rdoc.controller_file.should == @resource_name + '_controller.rb'
    end
  end

  context "when call simple name" do
    before do
      @resource_name = "One/Two"
      @rdoc = ResourceDoc.new @resource_name, nil
    end

    it "returns name without '/'" do
      @rdoc.simple_name.should == "OneTwo"
    end
  end

  context "when call get_controller_extractor function" do
    before do
      ResourceDoc.any_instance.stub( :generate_info ).and_return( true )
    end

    context "when exists controller file" do
      before do
        @rdoc = ResourceDoc.new "users", nil
      end

      it "returns new ControllerExtractor" do
        @rdoc.send( :get_controller_extractor ).class.should == ControllerExtractor
      end
    end

    context "when exists controller file" do
      before do
        @rdoc = ResourceDoc.new "notexists", nil
      end

      it "returns new ControllerExtractor" do
        @rdoc.send( :get_controller_extractor ).should == nil
      end
    end
  end

  context "when call get_actions_doc function" do
    before do
      ResourceDoc.any_instance.stub( :generate_info ).and_return( true )
      @rdoc = ResourceDoc.new "users", nil
    end

    context "when don't pass extractor" do
      before do
        @actions_doc = @rdoc.send( :get_actions_doc, @routes_actions_info, nil )
      end

      it "returns ActionDoc array" do
        @actions_doc.class.should == Array
        @actions_doc.each{ |ad| ad.class.should == ActionDoc }
      end

      it "don't returns description" do
        @actions_doc.each{ |ad| ad.description.should == nil }
      end

      it "ActionDoc array has correct info" do
        actions = @actions_doc.map{ |ad| ad.action }
        methods = @actions_doc.map{ |ad| ad.action_method }

        # Example of routes_actions_info: { index => [{},{}], show => [{}] }
        @routes_actions_info.each do |action_info|
          actions.should be_include( action_info[:action] )
          methods.should be_include( action_info[:method] )
        end
      end
    end

    context "when pass resource action info (routes) and extractor" do
      before do
        @actions_doc = @rdoc.send( :get_actions_doc, @routes_actions_info, @extractor )
      end

      it "returns ActionDoc array" do
        @actions_doc.class.should == Array
        @actions_doc.each{ |ad| ad.class.should == ActionDoc }
      end

      it "returns info extracted from controller" do
        @actions_doc.each do |action_doc|
          info = @extractor.get_action_info( action_doc.action )
          action_doc.description.should == info['description']
        end
      end
    end
  end

  context "when create new valid instance" do
    context "when use normal sintax" do
      before :all do
        @resource_name = "users"
        @rdoc = ResourceDoc.new @resource_name, @routes_actions_info
      end

      it "saves it correctly" do
        @rdoc.name.should == @resource_name
        @rdoc.controller_file.should == @resource_name + '_controller.rb'
      end

      it "set correct description" do
        @rdoc.description.should == [ @extractor.get_resource_info['description'] ]
      end

      it "set correct actions_doc" do
        @rdoc.actions_doc.class.should == Array
        @rdoc.actions_doc.each{ |ad| ad.class.should == ActionDoc }
      end
    end

    context "when description is an array" do
      before :all do
        @file_name = controller_dir 'resources_controller.rb'
        content = "# =begin resource\n# description:\n#   - Info1\n#   - Info2\n# =end\n"
        File.open( @file_name, 'w') { |file| file.write content }
        @rdoc = ResourceDoc.new "resource", []
      end

      after :all do
        File.delete( @file_name )
      end

      it "set correct description" do
        @rdoc.description.should == [ 'Info1', 'Info2' ]
      end
    end
  end
end
