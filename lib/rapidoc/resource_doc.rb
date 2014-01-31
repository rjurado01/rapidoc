# encoding: utf-8

module Rapidoc

  ##
  # This class includes all info about a resource
  # To extract info from controller file uses ControllerExtractor
  # It includes an array of ActionDoc with each action information
  #
  class ResourceDoc
    attr_reader :name, :description, :controller_file, :actions_doc

    ##
    # @param resource_name [String] resource name
    # @param routes_doc [RoutesDoc] routes documentation
    #
    def initialize( resource_name, routes_actions_info )
      @name = resource_name.to_s.split('/').last
      @controller_file = resource_name.to_s.pluralize + '_controller' + controllers_extension

      generate_info routes_actions_info
    end

    ##
    # Names with '/' caracter produce problems in html ids
    #
    def simple_name
      return self.name.delete '/'
    end

    private

    ##
    # Create description and actions_doc
    #
    def generate_info( routes_info )
      if routes_info
        extractor = get_controller_extractor
        @description = extractor.get_resource_info['description'] if extractor
        @actions_doc =  get_actions_doc( routes_info, extractor )

        # template need that description will be an array
        @description = [ @description ] unless @description.class == Array
      end
    end

    ##
    # @return [ControllerExtractor] extractor that allow read controller files
    # and extract action and resource info from them
    #
    def get_controller_extractor
      if File.exists? controller_dir( @controller_file )
        ControllerExtractor.new @controller_file
      else
        nil
      end
    end

    ##
    # @return [Array] all the resource ActionDoc
    #
    def get_actions_doc( routes_actions_info, extractor )
      routes_actions_info.map do |route_info|
        controller_info = extractor ? extractor.get_action_info( route_info[:action] ) : nil
        ActionDoc.new( route_info, controller_info, examples_dir )
      end
    end
  end
end
