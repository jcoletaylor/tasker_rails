# frozen_string_literal: true

require 'rubocop/rake_task'

task default: [:lint]

desc 'Run rubocop lint'
RuboCop::RakeTask.new(:lint) do |task|
  task.patterns = ['**/*.rb']
  task.fail_on_error = false
  task.options = ['--auto-correct-all']
end
