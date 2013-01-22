# encoding: utf-8
require 'rails'
module Rapidoc
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/rapidoc.rake'
    end
  end
end
