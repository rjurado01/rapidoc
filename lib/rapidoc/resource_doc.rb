# encoding: utf-8
# require_relative 'method_doc'

module Rapidoc

  class ResourceDoc
    attr_reader :name, :controller_file, :resource_actions, :description

    # Initializes ResourceDoc.
    def initialize(name, action_methods, options = {})
      @name = name
      @controller_file = name + '_controller.rb'
      @resource_actions = get_actions action_methods
      @description = nil
    end

    def get_actions( actions )
      extractor = ControllerExtractor.new controller_file
      actions_doc = extractor.get_actions_info

      actions_doc.map do |action|
        urls = actions.select{ |x| x["action"] == action["action"] }.map{ |x| x["url"] }
        ActionDoc.new action.merge( "urls" => urls )
      end
    end
  end
end
