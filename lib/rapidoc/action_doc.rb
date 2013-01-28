# encoding: utf-8

module Rapidoc

  class HttpResponse

    attr_reader :code, :description, :label

    def initialize( code )
      @code = code
      @description = get_description
      @label = get_label
    end

    def get_description
      case @code
        when 200
          'OK'
        when 201
          'Unauthorized'
        when 401
          'Not foun'
        when 422
          'Unprocessable Entity'
        when 403
          'Forbidden'
        else
          ''
      end
    end

    def get_label
      case @code
        when 200
          'label label-info'
        when 201
          'label label-success'
        when 401
          'label label-warning'
        when 422
          'label label-important'
        else
          'label'
      end
    end
  end

  class ActionDoc
    attr_reader :resource, :action, :action_method, :urls, :description,
      :http_responses, :response_formats, :file

    def initialize( resource, info, urls )
      @resource         = resource
      @urls             = urls
      @action           = info["action"]
      @action_method    = info["method"]
      @description      = info["description"]
      @http_responses   = get_http_responses info["http_responses"]
      @response_formats = info["response_format"]
      @file             = @resource + "_" + @action
    end

    def get_http_responses codes
      codes.map{ |c| HttpResponse.new c }
    end
  end
end
