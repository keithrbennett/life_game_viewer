$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'life-game-viewer'
  s.version     = '0.9.1'
  s.date        = Time.new
  s.summary     = "Game of Life Viewer"
  s.description = "Game of Life Viewer written in JRuby using Java Swing"
  s.authors     = ["Keith R. Bennett"]
  s.email       = 'keithrbennett@gmail.com'
  s.files       = Dir["README.md", "lib/**/*.rb", "resources/**/*"]
  s.homepage    = 'https://github.com/keithrbennett/life-game-viewer'
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
end