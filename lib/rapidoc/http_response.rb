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
          'Unauthorized'
        when 401
          'Not found'
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
end
