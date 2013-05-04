# encoding: utf-8

module Rapidoc

  ##
  # This class let us manage resources and actions extracted from 'rake routes'
  #
  class RoutesDoc
    def initialize
      @resources_routes = {}
    end

    def add_route( route )
      if route.split.size > 3
        method, url, controller_action = route.split.slice(1, 3)
      elsif route.split.size == 2
        url, controller_action = route.split
      else
        method, url, controller_action = route.split
      end

      # check when method is not specified
      unless controller_action.include? '#'
        controller_action = url
        url = method
        method = nil
      end

      add_resource_route( method, url, controller_action )
    end

    def get_resources_names
      @resources_routes.keys.sort
    end

    def get_resource_actions_names( resource )
      @resources_routes[resource.to_sym].map{ |route| route[:action] }.uniq
    end

    def get_actions_route_info( resource )
      get_resource_actions_names( resource ).map do |action|
        get_action_route_info( resource, action )
      end
    end

    def get_action_route_info( resource, action )
      urls = []
      controllers = []
      methods = []

      # compact and generate action info from all routes info of resource
      @resources_routes[resource.to_sym].each do |route|
        if route[:action] == action.to_s
          urls.push route[:url]
          controllers.push route[:controller]
          methods.push route[:method]
        end
      end

      return {
        resource: resource.to_s,
        action: action.to_s,
        method: methods.uniq.first,
        urls: urls.uniq,
        controllers: controllers.uniq
      }
    end

    private

    ##
    # Add new route info to resource routes array with correct format
    #
    def add_resource_route( method, url, controller_action )
      #resource = get_resource_name( url )
      resource = controller_action.split('#').first
      info =  {
        resource: resource,
        action: controller_action.split('#').last,
        method: method,
        url: url ,
        controller: controller_action.split('#').first
      }

      @resources_routes[resource.to_sym] ||= []
      @resources_routes[resource.to_sym].push( info )
    end

    ##
    # Extract resource name from url
    #
    def get_resource_name( url )
      new_url = url.gsub( '(.:format)', '' )

      return $1 if new_url =~ /\/(\w+)\/:id$/         # /users/:id (users)
      return $1 if new_url =~ /\/(\w+)\/:id\/edit$/   # /users/:id/edit (users)
      return $1 if new_url =~ /^\/(\w+)$/             # /users  (users)
      return $1 if new_url =~ /\/:\w*id\/(\w+)$/      # /users/:id/images (images)
      return $1 if new_url =~ /\/:\w*id\/(\w+)\/\w+$/ # /users/:id/config/edit (users)
      return $1 if new_url =~ /^\/(\w+)\/\w+$/        # /users/edit (users)
      return $1 if new_url =~ /\/(\w+)\/\w+\/\w+$/    # /users/password/edit (users)
      return url
    end
  end
end
