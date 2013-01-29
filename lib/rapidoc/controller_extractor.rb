module Rapidoc

  ##
  # This class open controller file and get all documentation blocks.
  # Lets us check if any of this blocks is a `rapidoc` block
  # and return it using `json` format.
  #
  # Rapidoc blocks must:
  # - have YAML format
  # - begin with `#=begin action` for actions description
  # - begin with `#=begin resource` for resource description
  # - end with `#=end`
  #
  class ControllerExtractor

    def initialize( controller_file )
      @lines = IO.readlines( controller_dir( controller_file ) )

      # gets init and end lines of each comment block
      init_doc_lines = @lines.each_index.select{ |i| @lines[i].include? "=begin" }
      end_doc_lines = @lines.each_index.select{ |i| @lines[i].include? "=end" }

      @blocks = init_doc_lines.each_index.map do |i|
        { :init => init_doc_lines[i], :end => end_doc_lines[i] }
      end
    end

    ##
    # Check all blocks and load those that are 'rapidoc actions block'
    # @return [Array] all actions info
    #
    def get_actions_info
      info = []
      @blocks = [] unless @blocks

      @blocks.each do |block|
        if @lines[ block[:init] ].include? "=begin action"
          n_lines = block[:end] - block[:init] - 1
          info << YAML.load( @lines[ block[:init] + 1, n_lines ].join.gsub(/\ *#/, '') )
        end
      end

      return info
    end

    ##
    # Check if exist a block with resource information 'rapidoc resource block'
    # @return [Hash] resource info
    #
    def get_resource_info
      @blocks ? info = [] : @blocks = []

      @blocks.each.map do |b|
        if @lines[ b[:init] ].include? "=begin resource"
          n_lines = b[:end] - b[:init] - 1
          info.push YAML.load( @lines[ b[:init] +1, n_lines ].join.gsub(/\ *#/, '') )
        end
      end

      return info.first
    end

    def get_controller_info
      { "description" => get_resource_info["description"], "actions" => get_actions_info }
    end

  end
end
