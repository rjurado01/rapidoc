module Rapidoc

  module ParamErrors

    def get_error_info( object, type )
      case type
      when 'required'
        get_required_error_info object
      when 'inclusion'
        get_inclusion_error_info object
      else
        nil
      end
    end

    def get_required_error_info( object )
      if default_errors and default_errors.include? "required"
        get_default_error_info( object, "required" )
      else
        {  "object" => object,
           "message" => "blank", 
           "description" => "This parameter is mandatory" }
      end
    end

    def get_inclusion_error_info( object )
      if default_errors and default_errors.include? "inclusion"
        get_default_error_info( object, "inclusion" )
      else
        { "object" => object, 
          "message" => "inclusion",
          "description" => "This parameter is not in the collection" }
      end
    end

    def get_default_error_info( object, type )
      { 'object' => object,
        'message' => default_errors[type]['message'],  # config function
        'description' => default_errors[type]['description']
      }
    end
  end
end
