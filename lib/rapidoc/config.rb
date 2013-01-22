# encoding: utf-8
module Rapidoc
  module Config
    GEM_CONFIG_DIR = File.join( File.dirname(__FILE__), 'config' )
    GEM_ASSETS_DIR = File.join( File.dirname(__FILE__), 'templates/assets' )

    def gem_templates_dir( f = nil )
     @gem_templates_dir ||= File.join( File.dirname(__FILE__), 'templates' )
     form_file_name @gem_templates_dir, f
    end

    def config_dir( f = nil )
      @config_dir ||= File.join( ::Rails.root.to_s, 'config/rapidoc' )
      form_file_name @config_dir, f
    end

    def target_dir( f = nil )
      @target_dir ||= File.join( ::Rails.root.to_s, 'rapidoc/' )
      form_file_name @target_dir, f 
    end

    def controller_dir(f = nil)
      @controller_dir ||= File.join( ::Rails.root.to_s, 'app/controllers/' )
      form_file_name @controller_dir, f
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
