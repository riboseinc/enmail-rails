# (c) 2018 Ribose Inc.
#

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "enmail/rails/version"

Gem::Specification.new do |spec|
  spec.name          = "enmail-rails"
  spec.version       = EnMail::Rails::VERSION
  spec.authors       = ["Ribose Inc."]
  spec.email         = ["open.source@ribose.com"]

  spec.summary       = "Encrypted Email in Action Mailer"
  spec.homepage      = "https://github.com/riboseinc/enmail-rails"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "enmail" # TODO ">= 0.2" when released

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "pry", "~> 0.11"
  spec.add_development_dependency "rake", ">= 10", "< 13"
  spec.add_development_dependency "rspec", "~> 3.0"
end
