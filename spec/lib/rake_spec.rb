require 'spec_helper'
require 'rake'

describe Rake do
  context 'rapidoc:generate' do
    before do
      Rake.application.rake_require "tasks/rapidoc"
      Rake::Task.define_task(:environment)
    end

    after do
      `rm -r #{::Rails.root.to_s + "/rapidoc"}`
    end

    let :run_rake_task do
      Rake::Task["rapidoc:generate"].reenable
      Rake.application.invoke_task "rapidoc:generate"
    end

    it "should create documentation" do
      run_rake_task
      File.exists?( ::Rails.root.to_s + "/rapidoc/index.html" ).should == true
    end
  end
end
