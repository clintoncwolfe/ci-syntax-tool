# -*-ruby-*-

require 'rake'
require 'bundler'
require 'rake/testtask'
require 'bundler/gem_tasks'
require 'cucumber'
require 'cucumber/rake/task'
require 'rubocop/rake_task'

namespace :test do
  desc 'Checks ruby files for syntax errors'
  task :syntax do
    puts '------------Syntax-----------'
    Dir.glob('**/*.rb').each do |f|
      system("/bin/echo -n '#{f}:  '; ruby -c #{f}")
    end
  end

  desc 'Run unit tests'
  Rake::TestTask.new do |t|
    t.name = 'unit'
    t.pattern = 'test/unit/**/*_spec.rb'
  end

  desc 'Run RuboCop'
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.patterns = ['bin/*']
    task.patterns = ['lib/**/*.rb']
    task.patterns = ['Rakefile']
  end

  Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = ['-f', 'progress', '--strict']
    unless ENV.key?('FC_FORK_PROCESS') \
          && ENV['FC_FORK_PROCESS'] == true.to_s
      t.cucumber_opts += ['-t', '~@build']
      t.cucumber_opts += ['-t', '~@context']
    end
    t.cucumber_opts += ['test/features']
  end
end

desc 'Runs all development tests'
task test: [:'test:syntax', :'test:rubocop', :'test:unit', :'test:features']
