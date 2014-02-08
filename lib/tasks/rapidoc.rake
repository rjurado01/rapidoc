include Rapidoc

namespace :rapidoc do

  desc "Generate config folder"
  task :install do
    create_config_structure
  end

  desc "Generate the api documentation"
  task :generate do
    if File.exists?( "#{::Rails.root}/config/rapidoc/rapidoc.yml" )
      load_config
      create_doc_structure
      puts "Generating API documentation..."
      generate_doc
      puts "Completed API documentation generation"
    else
      puts "Need install rapidoc for run it, for install run rapidoc:install task"
    end
  end

  desc "Remove the documentation"
  task :clean do
    remove_doc
  end
end
