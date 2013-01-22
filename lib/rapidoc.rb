require 'handlebars'
require "rapidoc/config"
require "rapidoc/version"
require "rapidoc/resource_doc"

module Rapidoc

  include Config

  METHODS = [ "GET", "PUT", "DELETE", "POST" ]

  def create_structure
    FileUtils.cp_r GEM_CONFIG_DIR + "/.", config_dir
    FileUtils.cp_r GEM_ASSETS_DIR, target_dir
  end

  # Reads 'rake routes' output and gets the controller info
  def get_controller_info
    controller_info = {}
    routes = Dir.chdir( ::Rails.root.to_s ) { `rake routes` }

    routes.split("\n").each do |entry|
      begin
        if entry.split.size == 4
          method, url, controller_action = entry.split.slice(1, 3)
        else
           method, url, controller_action = entry.split
        end

        if METHODS.include? method.upcase
          controller, action = controller_action.split('#')
          controller_info[controller] ||= []
          controller_info[controller] << { :action => action, :method => method,  :url => url }
        end
      rescue
      end
    end

    controller_info
  end

  def get_resources
    controller_info = get_controller_info
    resources = []

    controller_info.each do |controller, action_entries|
      controller_location = controller_dir(controller + '_controller.rb')
      resources << ResourceDoc.new(controller, action_entries, controller_location)
    end

    resources
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

  def generate_index_templates(resource_docs)
    config = YAML.load( File.read("#{config_dir}/rapidoc.yml") )

		template = get_index_template
    result = template.call( :info => config, :resources => get_resources )

    File.open( target_dir("index.html"), 'w' ) { |file| file.write result }
  end
end
