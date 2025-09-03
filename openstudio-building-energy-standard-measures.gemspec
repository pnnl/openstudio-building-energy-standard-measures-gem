
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'openstudio/building_energy_standard_measures/version'

Gem::Specification.new do |spec|
  spec.name          = 'openstudio-building-energy-standard-measures'
  spec.version       = OpenStudio::BuildingEnergyStandardMeasures::VERSION
  spec.authors       = ['']
  spec.email         = ['']

  spec.summary       = 'library and measures for OpenStudio'
  spec.description   = 'library and measures for OpenStudio'
  spec.homepage      = 'https://openstudio.net'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.5.0'
  if RUBY_VERSION < '3.2'
    spec.add_development_dependency 'bundler', '~> 2.1'
    spec.add_development_dependency 'rake', '~> 13.0'
    spec.add_development_dependency 'rspec', '~> 3.9'
    spec.add_development_dependency 'rubocop', '~> 0.54.0'

    spec.add_dependency 'openstudio-extension', '~> 0.3.1'
    spec.add_dependency 'openstudio-standards', '~> 0.2.12'
    spec.add_dependency 'openstudio_measure_tester', '~> 0.2.3'
  else
    spec.add_development_dependency 'bundler', '~> 2.4.10'
    spec.add_development_dependency 'rake', '~> 13.0.6'
    spec.add_development_dependency 'rspec', '~> 3.9'
    spec.add_development_dependency 'rubocop', '~> 1.50'

    spec.add_dependency 'openstudio-extension', '~> 0.8.1'
    spec.add_dependency 'openstudio-standards', '~> 0.8.2'
    spec.add_dependency 'openstudio_measure_tester', '~> 0.4.0'
  end
end
