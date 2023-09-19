# frozen_string_literal: true

require_relative "lib/rspec/custom/version"

Gem::Specification.new do |spec|
  spec.name          = "rspec-custom"
  spec.version       = Rspec::Custom::VERSION
  spec.authors       = ["Kristina Spurgin"]
  spec.email         = ["kristina@infomuse.net"]

  spec.summary       = "RSpec matchers for sharing across projects"
  spec.homepage      = "https://github.com/kspurgin/rspec-custom"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.1")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/kspurgin/rspec-custom"
  spec.metadata["changelog_uri"] = "https://github.com/kspurgin/rspec-custom/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) { `git ls-files -z`.split("\x0") }
  spec.require_paths = ["lib"]

  spec.add_dependency("rspec-core")
end
