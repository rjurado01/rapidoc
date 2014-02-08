require 'handlebars'
require "rapidoc/config"
require "rapidoc/version"
require "tasks/railtie.rb"
require "rapidoc/routes_doc"
require "rapidoc/resource_doc"
require "rapidoc/action_doc"
require "rapidoc/controller_extractor"
require "rapidoc/resources_extractor"
require "rapidoc/param_errors"
require "rapidoc/templates_generator"
require "rapidoc/yaml_parser"

module Rapidoc

  include Config
  include ResourcesExtractor
  include TemplatesGenerator
  include ParamErrors
  include YamlParser

  METHODS = [ "GET", "PUT", "DELETE", "POST" ]

  def create_config_structure
    FileUtils.cp_r GEM_CONFIG_DIR + "/.", config_dir unless File.directory? config_dir
    FileUtils.mkdir examples_dir unless File.directory? examples_dir
  end

  def create_doc_structure
    FileUtils.mkdir_p target_dir unless File.directory? target_dir
    FileUtils.mkdir_p actions_dir unless File.directory? actions_dir
    FileUtils.cp_r GEM_ASSETS_DIR, target_dir
  end

  def create_folders_for_file(file)
    route_dir = file.split("/")
    route_dir.pop
    route_dir = route_dir.join("/")
    FileUtils.mkdir route_dir unless File.directory? route_dir
  end

  def create_folders_for_files(files)
    files.each do |file|
      create_folders_for_file file
    end
  end

  def remove_structure
    remove_doc
    remove_config
  end

  def remove_config
    FileUtils.rm_r config_dir if File.directory? config_dir
  end

  def remove_doc
    FileUtils.rm_r "#{::Rails.root}/public/docs" if File.directory? "#{::Rails.root}/public/docs"
  end

  def reset_structure
    remove_structure
    create_structure
  end

  def remove_examples
    FileUtils.rm_r examples_dir if File.directory? examples_dir
  end

  def generate_doc
    resources_doc = get_resources
    generate_index_template( resources_doc )
    generate_actions_templates( resources_doc )
  end

end
