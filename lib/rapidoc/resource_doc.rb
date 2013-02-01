# encoding: utf-8
# require_relative 'method_doc'

module Rapidoc

  ##
  # This class include all info about a resource
  # For extract info from controller file use ControllerExtractor
  # It include an array of ActionDoc with each action information.
  #
  class ResourceDoc
    attr_reader :name, :controller_file, :actions_doc, :description, :routes_info

    ##
    # @param name resource name
    # @param routes_info is an array of hashes with this format:
    #   { :action => 'action', :resource => 'resource', :method => 'method', :url => 'url' }
    #
    def initialize( name, routes_info )
      @name = name
      @controller_file = name.to_s + '_controller.rb'
      @routes_info = routes_info

      get_controller_info
    end

    ##
    # Extract information from controller file
    #
    def get_controller_info
      if File.exists? controller_dir( @controller_file )
        extractor = ControllerExtractor.new @controller_file
      else
        extractor = nil
      end

      @description = get_description extractor
      @actions_doc =  get_actions_doc extractor
    end


    ##
    # Read resource description from controller file using controller_extractor
    # @return [String] resource description
    #
    def get_description( controller_extractor )
      if controller_extractor
        info = controller_extractor.get_resource_info
        info ? info["description"] : "not_found"
      else
        "not_controller"
      end
    end

    ##
    # @return [Array] resource ActionDoc.
    #
    def get_actions_doc( controller_extractor )
      if controller_extractor
        controller_extractor.get_actions_info.map do |action_info|
          urls = get_action_urls( action_info["action"] )
          ActionDoc.new( @name, action_info, urls, get_examples_dir )
        end
      end
    end

    ##
    # @return [Array] all urls from routes_info that include 'action' and 'resource'
    #
    def get_action_urls( action )
      if @routes_info
        @routes_info.select do |action_info|
          action_info[:action] == action and action_info[:resource] == @name.to_s
        end.map{ |a| a[:url] }
      end
    end
  end
end
