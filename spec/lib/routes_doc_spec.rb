require 'spec_helper.rb'

include Rapidoc

describe RoutesDoc do
  before do
    @routes_doc = RoutesDoc.new
  end

  context "when we call add_resource_route function" do
    before do
      @method = 'GET'
      @url = '/users(.:format)'
      @controller_action = 'users#index'
      @routes_doc.send( :add_resource_route, @method, @url, @controller_action )
    end

    it "adds new route to RoutesDoc instance" do
      @routes_doc.instance_variable_get( :@resources_routes ).size.should == 1
    end

    it "creates correct route resource" do
      resources =  @routes_doc.instance_variable_get( :@resources_routes ).keys
      resources.should be_include( :users )
    end

    it "set correct route info" do
      info = @routes_doc.instance_variable_get( :@resources_routes )[:users].first

      info[:resource].should == 'users'
      info[:action].should == 'index'
      info[:method].should == @method
      info[:url].should == @url
      info[:controller].should == 'users'
    end
  end

  context "when we call get_resource_name function" do
    context "when resource name is at the end of url" do
      context "when is embeded resource" do
        it "returns correct resource name" do
          name = @routes_doc.send( :get_resource_name, '/users/:id/images(.:format)' )
          name.should == 'images'
        end
      end

      context "when not is embeded resource" do
        it "returns correct resource name" do
          name = @routes_doc.send( :get_resource_name, '/users(.:format)' )
          name.should == 'users'
        end
      end
    end

    context "when resource name is followed by id" do
      it "returns correct resource name" do
        name = @routes_doc.send( :get_resource_name, '/users/:id/images/:id(.:format)' )
        name.should == 'images'
      end
    end

    context "when resource name is followed by action" do
      it "returns correct resource name" do
        name = @routes_doc.send( :get_resource_name, '/users/:id/images/new(.:format)' )
        name.should == 'images'
      end
    end

    context "when is edit action" do
      it "returns correct resource name" do
        name = @routes_doc.send( :get_resource_name, '/users/:id/edit(.:format)' )
        name.should == 'users'
      end
    end
  end

  context "when we call get_resources_names function" do
    it "returns all resources name" do
      @routes_doc.add_route( 'GET /users(.:format) users#index' )
      @routes_doc.add_route( 'GET /images(.:format) users#index' )
      @routes_doc.get_resources_names.should == [ :images, :users ]
    end
  end

  context "when we call get_resource_actions_names function" do
    it "returns all actions names" do
      @routes_doc.add_route( 'GET /users(.:format) users#index' )
      @routes_doc.add_route( 'GET /users(.:format) users#show' )
      @routes_doc.get_resource_actions_names( :users ).should == [ 'index', 'show' ]
    end
  end

  context "when we call add_route function" do
    before do
      @route = 'GET /users(.:format) users#index'
    end

    it "calls add_resource_route function with correct params" do
      @routes_doc.should_receive( :add_resource_route ).
        with( 'GET', '/users(.:format)', 'users#index' )
      @routes_doc.add_route( @route )
    end
  end

  context "when we call get_action_info function" do
    before do
      @route = 'GET /users(.:format) users#index'
    end

    it "returns correct Hash" do
      @routes_doc.add_route( @route )
      @routes_doc.get_action_route_info( :users, :index ).should == {
        resource: 'users',
        action: 'index',
        method: 'GET',
        urls: ['/users(.:format)'],
        controllers: [ 'users' ]
      }
    end
  end

  context "when we call get_resource_actions_info function" do
    before do
      @routes_doc.add_route( 'GET /users(.:format) users#index' )
      @routes_doc.add_route( 'GET /users(.:format) users#show' )
      @actions_info = @routes_doc.get_actions_route_info( 'users' )
    end

    it "returns all actions info" do
      @actions_info.should be_include(
        @routes_doc.get_action_route_info( 'users', 'index' ) )
      @actions_info.should be_include(
        @routes_doc.get_action_route_info( 'users', 'show' ) )
    end
  end
end
