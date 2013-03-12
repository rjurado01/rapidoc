# encoding: utf-8

module Rapidoc

  ##
  # This module has all config information about directories and config files.
  #
  module Config
    GEM_CONFIG_DIR = File.join( File.dirname(__FILE__), 'config' )
    GEM_ASSETS_DIR = File.join( File.dirname(__FILE__), 'templates/assets' )
    GEM_EXAMPLES_DIR = File.join( File.dirname(__FILE__), 'config/examples')

    @@config = nil

    def gem_templates_dir( f = nil )
     gem_templates_dir ||= File.join( File.dirname(__FILE__), 'templates' )
     form_file_name gem_templates_dir, f
    end

    def config_dir( f = nil )
      config_dir ||= File.join( ::Rails.root.to_s, 'config/rapidoc' )
      form_file_name config_dir, f
    end

    def controller_dir(f = nil)
      controller_dir ||= File.join( ::Rails.root.to_s, 'app/controllers' )
      form_file_name controller_dir, f
    end

    def config_file_path
      config_dir 'rapidoc.yml'
    end

    def rapidoc_config
      @@config
    end

    def load_config
      if File.exists?( config_file_path )
        @@config = YAML.load( File.read( config_file_path ) )
      end
    end

    def resources_black_list
      if @@config and @@config['resources_black_list']
        @@config['resources_black_list'].gsub(' ', '').split(',').map(&:to_sym)
      else
        return []
      end
    end

    def default_errors?
      @@config and @@config['default_errors'] == true
    end

    def default_errors
      @@config and @@config['errors'] ? @@config['errors'] : nil
    end

    # return the directory where rapidoc generates the doc
    def target_dir( f = nil )
      if File.exists?( config_file_path )
        form_file_name( target_dir_from_config, f )
      else
        form_file_name( File.join( ::Rails.root.to_s, 'rapidoc' ), f )
      end
    end

    # returns the directory where rapidoc generates actions (html files)
    def actions_dir( f = nil )
      f ? target_dir( "actions/#{f}" ) : target_dir( "actions" )
    end

    # returns the directory where rapidoc searches for examples
    def examples_dir( f = nil )
      if File.exists?( config_file_path )
        form_file_name( examples_dir_from_config_file, f )
      else
        form_file_name( config_dir( '/examples' ), f )
      end
    end

    private

    def target_dir_from_config
      if @@config and @@config.has_key?( "doc_route" )
        File.join(::Rails.root.to_s, @@config['doc_route'] )
      else
        File.join(::Rails.root.to_s, 'rapidoc' )
      end
    end

    def examples_dir_from_config_file
      if @@config and @@config.has_key?("examples_route")
        File.join( ::Rails.root.to_s, @@config["examples_route"] )
      else
        config_dir '/examples'
      end
    end

    def form_file_name(dir, file)
      case file
      when NilClass then dir
      when String then File.join(dir, file)
      else raise ArgumentError, "Invalid argument #{file}"
      end
    end
  end
end
