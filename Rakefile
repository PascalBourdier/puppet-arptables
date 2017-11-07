require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-strings/tasks'

exclude_paths = [
  'pkg/**/*',
  'vendor/**/*',
  'spec/**/*',
  'examples/**/*'
]

# Make sure we don't have the default rake task floating around
Rake::Task['lint'].clear

PuppetLint.configuration.relative = true
PuppetLint::RakeTask.new(:lint) do |l|
  l.disable_checks = %w(80chars class_inherits_from_params_class)
  l.ignore_paths = exclude_paths
  l.fail_on_warnings = true
  l.log_format = '%{path}:%{line}:%{check}:%{KIND}:%{message}'
end

PuppetSyntax.exclude_paths = exclude_paths

namespace :travis do
  desc 'Syntax check travis.yml'
  task :lint do
    # warnings are currently non-fatal due to suspected problems with
    # validation of matrix::include
    #sh "travis lint --exit-code" do |ok, res|
    sh 'travis lint --skip-completion-check' do |ok, res|
      unless ok
        # exit without verbose rake error message
        exit res.exitstatus
      end
    end
  end
end

desc 'Run tests metadata_lint, release_checks'
task test: [
  :metadata_lint,
  :release_checks,
]

default_tasks = [
  :lint,
  :validate,
  :parallel_spec,
]

task :default => default_tasks
