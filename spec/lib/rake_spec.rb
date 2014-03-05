require 'spec_helper'
require 'rake'

def capture_stdout(&block)
  original_stdout = $stdout
  $stdout = fake = StringIO.new
  begin
    yield
  ensure
    $stdout = original_stdout
  end
  fake.string
end

describe Rake do
  before :all do
    Rake.application.rake_require "tasks/rapidoc"
    Rake::Task.define_task(:environment)
  end

  let :install_task do
    Rake::Task["rapidoc:install"].reenable
    Rake.application.invoke_task "rapidoc:install"
  end

  let :generate_task do
    Rake::Task["rapidoc:generate"].reenable
    Rake.application.invoke_task "rapidoc:generate"
  end

  let :clean_task do
    Rake::Task["rapidoc:clean"].reenable
    Rake.application.invoke_task "rapidoc:clean"
  end

  context "rapidoc:install" do
    before do
      install_task
    end

    after :all do
      remove_structure
    end

    it "create directory and files" do
      File.directory?("#{::Rails.root}/config/rapidoc").should be_true
      File.directory?("#{::Rails.root}/config/rapidoc/examples").should be_true
      File.exists?( "#{::Rails.root}/config/rapidoc/rapidoc.yml" ).should be_true
    end
  end

  context 'rapidoc:generate' do
    context "when rapidoc is installed" do
      before do
        install_task
      end

      after :all do
        remove_structure
      end

      it "create documentation" do
        output = capture_stdout { generate_task }
        output.should be_include( 'Generating API documentation...' )
        output.should be_include( 'Completed API documentation generation' )
        File.exists?( "#{::Rails.root}/public/docs/index.html" ).should be_true
      end
    end

    context "when rapidoc is not installed" do
      after :all do
        remove_structure
      end

      it "show a message with information" do
        output = capture_stdout { generate_task }
        output.should be_include( 'Need install rapidoc for run it, for install run rapidoc:install task' )
        File.exists?( "#{::Rails.root}/public/docs/index.html" ).should be_false
      end
    end
  end

  context "rapidoc:clean" do
    before do
      install_task
      capture_stdout { generate_task }
      clean_task
    end

    after :all do
      remove_structure
    end

    it "remove docs files" do
      File.directory?("#{::Rails.root}/public/docs").should be_false
      File.directory?("#{::Rails.root}/config/rapidoc").should be_true
      File.exists?( "#{::Rails.root}/config/rapidoc/rapidoc.yml" ).should be_true
    end
  end
end
