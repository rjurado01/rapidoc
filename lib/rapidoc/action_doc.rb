# encoding: utf-8

require 'rapidoc/http_response'

module Rapidoc

  ##
  # This class save information about action of resource.
  #
  class ActionDoc
    attr_reader :resource, :action, :action_method, :urls, :description,
      :http_responses, :response_formats, :file, :params, :errors

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
      @response_formats = action_info["response_format"]
      @params           = action_info["params"]
      @file             = resource.to_s + "_" + @action.to_s
      @http_responses   = get_http_responses action_info["http_responses"]
      @errors           = action_info["errors"] ? action_info["errors"] : []

      load_params_error if @params
    end

    def get_http_responses codes
      codes.map{ |c| HttpResponse.new c } if codes
    end

    def load_params_error
      @params.each do |param|
        if param["required"] and param["required"] == true
          @errors << { "object" => param["name"], "message" => "blank" }
        end

        if param["include"]
          @errors << { "object" => param["name"], "message" => "inclusion" }
        end
      end
    end
  end
end
