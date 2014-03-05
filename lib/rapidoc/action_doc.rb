# encoding: utf-8

require 'rapidoc/http_response'
require 'json'

module Rapidoc

  ##
  # This class save information about action of resource.
  #
  class ActionDoc
    attr_reader :resource, :urls, :action, :action_method, :description,
      :response_formats, :authentication, :params, :file, :http_responses,
      :errors, :example_res, :example_req, :resource_name

    ##
    # @param resource [String] resource name
    # @param action_info [Hash] action info extracted from controller file
    # @param urls [Array] all urls that call this method
    #
    def initialize( routes_info, controller_info, examples_route )
      @resource_name    = routes_info[:resource].split('/').last
      @resource         = routes_info[:resource].to_s
      @action           = routes_info[:action].to_s
      @action_method    = routes_info[:method].to_s || '-----'
      @urls             = routes_info[:urls]
      @file             = @resource + '_' + @action

      puts " - Generating #{@action} action documentation..." if trace?

      add_controller_info( controller_info ) if controller_info
      load_examples( examples_route ) if examples_route
      load_params_errors if default_errors? @action and @params
    end

    def has_controller_info
      @controller_info ? true : false
    end

    private

    def add_controller_info( controller_info )
      puts "  + Adding info from controller..." if trace?
      @description      = controller_info["description"]
      @response_formats = default_response_formats || controller_info["response_formats"]
      @params           = controller_info["params"]
      @http_responses   = get_http_responses controller_info["http_responses"]
      @errors           = controller_info["errors"] ? controller_info["errors"].dup : []
      @authentication   = get_authentication controller_info["authentication_required"]
      @controller_info  = true
    end

    def get_authentication( required_authentication )
      if [ true, false ].include? required_authentication 
        required_authentication
      else
        default_authentication
      end
    end

    def get_http_responses codes
      codes.map{ |c| HttpResponse.new c } if codes
    end

    def load_examples( examples_route )
      return unless File.directory? examples_route + "/"
      load_request examples_route
      load_response examples_route
    end

    def load_params_errors
      @params.each do |param|
        @errors << get_error_info( param["name"], "required" ) if param["required"]
        @errors << get_error_info( param["name"], "inclusion" ) if param["inclusion"]
      end
    end

    def load_request( examples_route )
      file = examples_route + '/' + @resource + '_' + @action + '_request.json'
      return unless File.exists?( file )
      puts "  + Loading request examples..." if trace?
      File.open( file ){ |f| @example_req = JSON.pretty_generate( JSON.parse(f.read) ) }
    end

    def load_response( examples_route )
      file = examples_route + '/' + @resource + '_' + @action + '_response.json'
      return unless File.exists?( file )
      puts "  + Loading response examples..." if trace?
      File.open( file ){ |f| @example_res = JSON.pretty_generate( JSON.parse(f.read) ) }
    end
  end
end
