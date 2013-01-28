# encoding: utf-8
# require_relative 'method_doc'

module Rapidoc

  class ResourceDoc
    attr_reader :name, :controller_file, :actions, :description, :actions_info

    def initialize( name, actions_info, options = {} )
      @name = name
      @controller_file = name + '_controller.rb'
      @actions = actions_info
      @extractor = ControllerExtractor.new controller_file
      @description = get_description
      @actions_info =  get_actions_info
    end

    def get_description
      if @extractor.valid?
        info = @extractor.get_resource_info
        info ? info["description"] : "Without description."
      else
        "Not controller found."
      end
    end

    def get_actions_info
      actions_doc = []

      @extractor.get_actions_info.each do |action|
        urls = @actions.select do |a|
          a[:action] == action["action"] and a[:resource] == @name
        end.map{ |a| a[:url] }

        actions_doc << ActionDoc.new( @name, action, urls )
      end

      return actions_doc
    end
  end
end
