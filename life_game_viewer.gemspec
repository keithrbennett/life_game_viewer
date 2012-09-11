# -*- encoding: utf-8 -*-
require File.expand_path('../lib/life_game_viewer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Keith Bennett"]
  gem.email         = ["keithrbennett@gmail.com"]
  gem.summary     = "Game of Life Viewer"
  gem.description = "Game of Life Viewer written in JRuby using Java Swing"
  gem.homepage    = 'https://github.com/keithrbennett/life_game_viewer'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "life_game_viewer"
  gem.require_paths = ["lib"]
  gem.version       = LifeGameViewer::VERSION
end
