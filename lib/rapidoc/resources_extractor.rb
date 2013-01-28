module Rapidoc

  ##
  # This module get resources info.
  #
  # Info of each route include:
  # - method
  # - action
  # - url
  # - controller_file
  #
  module ResourcesExtractor

    # Reads 'rake routes' output and gets the resources info
    def get_resources_info
      resource_info = {}
      routes = Dir.chdir( ::Rails.root.to_s ) { `rake routes` }

      routes.split("\n").each do |entry|
        begin
          if entry.split.size == 4
            method, url, controller_action = entry.split.slice(1, 3)
          else
             method, url, controller_action = entry.split
          end

          if METHODS.include? method.upcase
            resource, action = controller_action.split('#')
            resource_info[resource] ||= []
            resource_info[resource] << { :resource => resource, :action => action,
              :method => method,  :url => url }
          end
        rescue
        end
      end

      resource_info
    end

    def get_resources
      resources_info = get_resources_info.sort
      resources = []

      resources_info.each do |resource, action_entries|
        resources << ResourceDoc.new( resource, order_actions( action_entries ) )
      end

      resources
    end

    def order_actions actions
      if actions
        methods = actions.map{ |action| action[:method] }.uniq
        info =[]

        methods.each do |method|
          actions.each{ |action| info << action if action[:method] == method }
        end

        return info
      end
    end
  end
end
