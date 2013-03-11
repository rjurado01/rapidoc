include Rapidoc

namespace :rapidoc do

  desc "Generate the api documentation"
  task :generate do
    load_config
    create_structure
    puts "Generating API documentation..."
    generate_doc
    puts "Completed API documentation generation"
  end

  desc "Generate the config files"
  task :clean do
    remove_doc
  end
end
