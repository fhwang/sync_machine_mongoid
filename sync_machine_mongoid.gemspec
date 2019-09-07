lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sync_machine/mongoid/version"

Gem::Specification.new do |spec|
  spec.name          = "sync_machine_mongoid"
  spec.version       = SyncMachine::Mongoid::VERSION
  spec.authors       = ["Francis Hwang"]
  spec.email         = ["sera@fhwang.net"]

  spec.summary       = %q{Mongoid adapter for SyncMachine.}
  spec.description   = %q{Mongoid adapter for SyncMachine.}
  spec.homepage      = "https://github.com/fhwang/sync_machine_mongoid"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/fhwang/sync_machine_mongoid"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "fhwang-wisper-mongoid", ">= 0.2.3"
  spec.add_runtime_dependency "mongoid"
  spec.add_runtime_dependency "sync_machine", ">= 0.3.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "factory_bot"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec_junit_formatter"
end