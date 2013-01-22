# encoding: utf-8
# require_relative 'method_doc'

module Rapidoc

  class ResourceDoc
    attr_reader :name, :resource_location, :controller_name, :class_block,
      :function_blocks, :resource_header, :resource_methods, :description

    # Initializes ResourceDoc.
    def initialize(name, action_methods, controller_location, options = {})
      @name = name
      @class_block = nil
      @function_blocks = []
      @resource_methods = action_methods
      @resource_header = ""
      @standard_methods = options[:standard_methods] || [:put, :post, :get, :delete]
      @resource_location = resource_location
      @controller_location = controller_location
      @description = nil
      @controller_name = File.basename(controller_location)
    end
  end

end
