require 'handlebars'
require "rapidoc/config"
require "rapidoc/version"
require "tasks/railtie.rb"
require "rapidoc/resource_doc"
require "rapidoc/action_doc"
require "rapidoc/controller_extractor"
require "rapidoc/resources_extractor"

module Rapidoc

  include Config
  include ResourcesExtractor

  METHODS = [ "GET", "PUT", "DELETE", "POST" ]

  def create_structure
    FileUtils.mkdir target_dir unless File.directory? target_dir
    FileUtils.cp_r GEM_CONFIG_DIR + "/.", config_dir
    FileUtils.cp_r GEM_ASSETS_DIR, target_dir
  end

  def remove_structure
    FileUtils.rm_r target_dir
  end

  def generate_doc(resource_docs)
    generate_index_templates(resource_docs)
  end

  # Get bootstrap label for a method
  def get_method_label( method )
    case method
    when 'GET'
      'label label-info'
    when 'POST'
      'label label-success'
    when 'PUT'
      'label label-warning'
    when 'DELETE'
      'label label-important'
    else
      'label'
    end
  end

  def get_index_template
    template = IO.read( gem_templates_dir('index.html.hbs') )
    handlebars = Handlebars::Context.new

    handlebars.register_helper('method_label') do |this, context, block|
      get_method_label( block.call(context) )
    end

    handlebars.compile( template )
  end

  def generate_index_templates( resource_docs )
    config = YAML.load( File.read("#{config_dir}/rapidoc.yml") )

    template = get_index_template
    result = template.call( :info => config, :resources => resource_docs )

    File.open( target_dir("index.html"), 'w' ) { |file| file.write result }
  end

end
