module Rapidoc

  ##
  # This module let generate index file and actions files from templates.
  #
  module TemplatesGenerator

    def generate_index_template( resources_doc )
      config = YAML.load( File.read("#{config_dir}/rapidoc.yml") )

      template = get_index_template
      result = template.call( :info => config, :resources => resources_doc )

      File.open( target_dir("index.html"), 'w' ) { |file| file.write result }
    end

    def get_index_template
      template = IO.read( gem_templates_dir('index.html.hbs') )
      handlebars = Handlebars::Context.new

      handlebars.register_helper('method_label') do |this, context, block|
        get_method_label( block.fn(context) )
      end

      handlebars.compile( template )
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

    def generate_actions_templates( resources_doc )
      resources_doc.each do |resource|
        if resource.actions_doc
          resource.actions_doc.each do |action_doc|
            create_action_template( get_action_template, action_doc )
          end
        end
      end
    end

    def create_action_template( template, action_doc )
      config = YAML.load( File.read("#{config_dir}/rapidoc.yml") )
      result = template.call( :info => config, :action => action_doc )

      File.open( actions_dir("#{action_doc.file}.html"), 'w' ) { |file| file.write result }
    end

    def get_action_template
      template = IO.read( gem_templates_dir('action.html.hbs') )
      handlebars = Handlebars::Context.new
      handlebars.compile( template )
    end

  end
end
