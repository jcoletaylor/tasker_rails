require 'rubocop/rake_task'

task default: [:rubocop]

desc 'Run rubocop'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['**/*.rb']
  task.fail_on_error = false
  task.options = ['--auto-correct-all']
end
