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
  context 'rapidoc:generate' do
    before do
      Rake.application.rake_require "tasks/rapidoc"
      Rake::Task.define_task(:environment)
    end

    after do
      remove_doc 
    end

    let :run_rake_task do
      Rake::Task["rapidoc:generate"].reenable
      Rake.application.invoke_task "rapidoc:generate"
    end

    it "should create documentation" do
      output = capture_stdout { run_rake_task }
      output.should be_include( 'Generating API documentation...' )
      output.should be_include( 'Completed API documentation generation' )

      File.exists?( ::Rails.root.to_s + "/rapidoc/index.html" ).should == true
    end
  end
end
