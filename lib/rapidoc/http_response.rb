# encoding: utf-8

module Rapidoc

  ##
  # Represent http status code with code and description.
  # Also include bootstrap label for code.
  #
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
          'Created'
        when 204
          'No content'
        when 401
          'Unauthorized'
        when 403
          'Forbidden'
        when 404
          'Not found'
        when 422
          'Unprocessable Entity'
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
        when 204
          'label label-info2'
        when 401
          'label label-warning'
        when 403
          'label label-warning2'
        when 422
          'label label-important'
        when 404
          'label label-inverse'
        else
          'label'
      end
    end
  end
end
