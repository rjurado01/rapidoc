require 'spec_helper'

include Rapidoc

describe TemplatesGenerator do

  before do
    reset_structure
    load_config
  end

  after do
    #remove_doc
  end

  context "when call generate_index_template" do
    it "should create new index.html file" do
      generate_index_template nil
      File.exists?( target_dir + '/index.html' ).should == true
    end
  end

  context "when call get_index_template function" do
    it "should return Handlebars Template " do
      @template = get_index_template
      @template.class.should == Handlebars::Template
    end
  end

  context "when call generate_actions_templates function" do
    before do
      @resources = get_resources.select{ |r| r.actions_doc }
      generate_actions_templates @resources
    end

    it "should create new action.html file for each action"do
      @resources.each do |resource|
        resource.actions_doc.each do |action_doc|
          if action_doc.has_controller_info
            route = actions_dir + "/#{resource.name}_#{action_doc.action}.html"
            File.exists?( route ).should == true
          end
        end
      end
    end
  end

  context "when call create_action_template function" do
    before do
      extractor = ControllerExtractor.new "users_controller.rb"
      resource_info = get_routes_doc.get_actions_route_info( :users )

      info = resource_info.group_by{ |entrie| entrie[:action] }['create'].first
      controller_info = extractor.get_action_info( 'create' )
      @action_doc = ActionDoc.new( info, controller_info, examples_dir )
      
      create_action_template( get_action_template, @action_doc )
    end

    it "should create new action html file" do
      route = actions_dir + "/#{@action_doc.resource}_#{@action_doc.action}.html"
      File.exists?( route ).should == true
    end
  end

  context "when call get_action_template function" do
    it "should return Handlebars Template " do
      @template = get_action_template
      @template.class.should == Handlebars::Template
    end
  end

  context "when call get_method_label" do
    context "when call with valid method" do
      before do
        @methods = [ 'GET', 'POST', 'PUT', 'DELETE' ]
        @labels = [ 'label-info', 'label-success', 'label-warning', 'label-important' ]
      end

      it "should return correct label" do
        @methods.each_index do |i|
          get_method_label( @methods[i] ).should == 'label ' + @labels[i]
        end
      end
    end

    context "when call with unknow method" do
      it "should return correct label" do
        get_method_label( 'unknow' ).should == 'label'
      end
    end
  end
end
