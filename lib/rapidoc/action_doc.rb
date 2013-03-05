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
      :errors, :examples_route, :example_res, :example_req

    ##
    # @param resource [String] resource name
    # @param action_info [Hash] action info extracted from controller file
    # @param urls [Array] all urls that call this method
    #
    def initialize( resource, action_info, urls, examples_route = "" )
      @resource         = resource
      @urls             = urls
      @action           = action_info["action"]
      @action_method    = action_info["method"]
      @description      = action_info["description"]
      @response_formats = action_info["response_formats"]
      @authentication   = action_info["requires_authentication"]
      @params           = action_info["params"]
      @file             = resource.to_s + "_" + @action.to_s
      @http_responses   = get_http_responses action_info["http_responses"]
      @errors           = action_info["errors"] ? action_info["errors"] : []
      @examples_route   = examples_route
      @example_res      = ""
      @example_req      = ""

      #load_params_error if @params
      load_examples
    end

    private 

    def get_http_responses codes
      codes.map{ |c| HttpResponse.new c } if codes
    end

    def load_params_error
      @params.each do |param|
        if param["required"] and param["required"] == true
          @errors << { "object" => param["name"], "message" => "blank" }
        end

        if param["inclusion"]
          @errors << { "object" => param["name"], "message" => "inclusion" }
        end
      end
    end

    def load_examples
      return unless File.directory? @examples_route + "/"
      load_request
      load_response
    end

    def load_request
      return unless File.exists?( @examples_route + '/' + @file + '_request.json' )
      File.open(@examples_route + '/' + @file + '_request.json', 'r') { |f|
        @example_req = JSON.pretty_generate( JSON.parse( f.read ) ) }
    end

    def load_response
      return unless File.exists?( @examples_route + '/' + @file + '_response.json' )
      File.open(@examples_route + '/' + @file + '_response.json', 'r') { |f|
        @example_res = JSON.pretty_generate( JSON.parse( f.read ) ) }
    end
  end
end
