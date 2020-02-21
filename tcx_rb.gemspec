# frozen_string_literal: true

require_relative 'lib/tcx_rb/version'

Gem::Specification.new do |spec|
  spec.name          = 'tcx_rb'
  spec.version       = TcxRb::VERSION
  spec.authors       = ['Keith Doggett']
  spec.email         = ['keith.doggett887@gmail.com']

  spec.summary       = 'TcxRB is a Garminc TCX parsing library for Ruby.'
  spec.description   =
    'TcxRB is a Garmin TCX parsing library for Ruby. '\
    'It gives access to raw data and has helpful aggregate '\
    'functions for groups of data.'
  spec.homepage      = 'https://github.com/Kdoggett887/tcx_rb'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  # spec.metadata['changelog_uri'] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.add_dependency 'nokogiri', '~>1.10'
  spec.add_development_dependency 'minitest', '~>5.0'
  spec.add_development_dependency 'rake', '~>12.0'

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
