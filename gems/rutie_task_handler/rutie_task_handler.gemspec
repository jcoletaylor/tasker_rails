# frozen_string_literal: true

require_relative 'lib/rutie_task_handler/version'

Gem::Specification.new do |spec|
  spec.name          = 'rutie_task_handler'
  spec.version       = RutieTaskHandler::VERSION
  spec.authors       = ['Pete Taylor']
  spec.email         = ['pete.jc.taylor@hey.com']

  spec.summary       = 'Dummy Rutie Task Handler for Tasker Rails'
  spec.description   = 'Dummy Rutie Task Handler for Tasker Rails'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.7.3')

  spec.metadata['source_code_uri'] = 'https://github.com/jcoletaylor/tasker_rails'

  spec.add_dependency 'ffi'
  spec.add_dependency 'json'
  spec.add_dependency 'rutie', '~> 0.0.3'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files =
    Dir.chdir(File.expand_path('..', __FILE__)) do
      `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
    end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
