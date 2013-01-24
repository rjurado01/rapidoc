# encoding: utf-8
# require_relative 'method_doc'

module Rapidoc

  class ResourceDoc
    attr_reader :name, :controller_file, :resource_methods, :description

    # Initializes ResourceDoc.
    def initialize(name, action_methods, controller_file, options = {})
      @name = name
      @resource_methods = action_methods
      @controller_file = controller_file
      @description = nil
    end
  end

end
