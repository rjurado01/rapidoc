# encoding: utf-8

require 'rapidoc/http_response'

module Rapidoc

  ##
  # This class save information about action of resource.
  #
  class ActionDoc
    attr_reader :resource, :action, :action_method, :urls, :description,
      :http_responses, :response_formats, :file

    ##
    # @param resource [String] resource name
    # @param action_info [Hash] action info extracted from controller file
    # @param urls [Array] all urls that call this method
    #
    def initialize( resource, action_info, urls )
      @resource         = resource
      @urls             = urls
      @action           = action_info["action"]
      @action_method    = action_info["method"]
      @description      = action_info["description"]
      @http_responses   = get_http_responses action_info["http_responses"]
      @response_formats = action_info["response_format"]
      @file             = @resource.to_s + "_" + @action.to_s
    end

    def get_http_responses codes
      codes.map{ |c| HttpResponse.new c } if codes
    end
  end
end
