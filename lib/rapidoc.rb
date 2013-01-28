require 'handlebars'
require "rapidoc/config"
require "rapidoc/version"
require "tasks/railtie.rb"
require "rapidoc/resource_doc"
require "rapidoc/action_doc"
require "rapidoc/controller_extractor"
require "rapidoc/resources_extractor"
require "rapidoc/templates_generator"

module Rapidoc

  include Config
  include ResourcesExtractor
  include TemplatesGenerator

  METHODS = [ "GET", "PUT", "DELETE", "POST" ]

  def create_structure
    FileUtils.mkdir target_dir unless File.directory? target_dir
    FileUtils.cp_r GEM_CONFIG_DIR + "/.", config_dir unless File.directory? GEM_CONFIG_DIR
    FileUtils.cp_r GEM_ASSETS_DIR, target_dir
  end

  def remove_structure
    FileUtils.rm_r target_dir
  end

  def generate_doc(resources_doc)
    generate_index_template( resources_doc )
    generate_actions_templates( resources_doc )
  end

end
