include Rapidoc

namespace :rapidoc do

  desc "Generate the api documentation"
  task :generate => :environment do
    create_structure
    resources = get_resources

    if !resources.empty?
      puts "Generating API documentation..."
      generate_doc(resources)
      puts "Completed API documentation generation"
    end
  end

  desc "Generate the config files"
  task :clean => :environment do
    remove_structure
  end
end
