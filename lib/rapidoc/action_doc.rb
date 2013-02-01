# encoding: utf-8

require 'rapidoc/http_response'

module Rapidoc

  ##
  # This class save information about action of resource.
  #
  class ActionDoc
    attr_reader :resource, :action, :action_method, :urls, :description,
      :http_responses, :response_formats, :file, :examples_route, :example_res, :example_req

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
      @http_responses   = get_http_responses action_info["http_responses"]
      @response_formats = action_info["response_format"]
      @file             = @resource.to_s + "_" + @action.to_s
      @examples_route   = examples_route
      @example_res      = ""
      @example_req      = ""
      load_examples
    end

    def get_http_responses codes
      codes.map{ |c| HttpResponse.new c } if codes
    end

    def load_examples
      return unless File.directory? @examples_route + "/"
      load_request
      load_response
    end

    def load_request
      return unless File.exists?( @examples_route + '/' + @file + '_request.yml' )
      File.open(@examples_route + '/' + @file + '_request.yml', 'r') { |f|
        @example_req = JSON.parse( f.read ) }

      pp @example_req
      @example_req = JSON.pretty_generate( @example_req )
    end

    def load_response
      return unless File.exists?( @examples_route + '/' + @file + '_response.yml' )
      File.open(@examples_route + '/' + @file + '_response.yml', 'r') { |f|
        @example_res = JSON.pretty_generate(JSON.parse( f.read )).to_s }
    end
  end
end
