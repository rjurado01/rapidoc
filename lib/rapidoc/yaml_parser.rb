module Rapidoc

  ##
  # This module parse controllers comments to yaml format
  #
  module YamlParser

    ##
    # Check if exist a block with resource information 'rapidoc resource block'
    #
    # @param lines [Array] lines that contain comments
    # @param blocks [Hash] lines of blocks, example: { init: 1, end: 4 }
    # @return [Hash] resource info
    #
    def extract_resource_info( lines, blocks, file_name )
      blocks ? info = [] : blocks = []

      blocks.each.map do |b|
        if lines[ b[:init] ].include? "=begin resource"
          n_lines = b[:end] - b[:init] - 1
          
          begin
            info.push YAML.load( lines[ b[:init] +1, n_lines ].join.gsub(/\ *#/, '') )
          rescue SyntaxError => e
            puts "Error parsing block in #{file_name} file [#{b[:init]} - #{b[:end]}]"
          end
        end
      end

      info.first ? info.first : {}
    end

    ##
    # Check all blocks and load those that are 'rapidoc actions block'
    #
    # @param lines [Array] lines that contain comments
    # @param blocks [Hash] lines of blocks, example: { init: 1, end: 4 }
    # @return [Array] all actions info
    #
    def extract_actions_info( lines, blocks, file_name )
      info = []
      blocks = [] unless blocks

      blocks.each do |b|
        if lines[ b[:init] ].include? "=begin action"
          n_lines = b[:end] - b[:init] - 1
          
          begin
            info << YAML.load( lines[ b[:init] + 1, n_lines ].join.gsub(/\ *#/, '') )
          rescue Exception => e
            puts "Error parsing block in #{file_name} file [#{b[:init]} - #{b[:end]}]"
          end
        end
      end

      return info
    end
  end
end
