life_game_viewer
================

This is a JRuby application that uses Java's Swing UI library
to render generations of Conway's Game of Life.

My intention in writing it was to provide a GUI player
with which developers could view and test their implementations
of the Game of Life exercise.

In order to do the exercise, you will need to effectively replace the
LifeModel's implementation with your own.  You will need to
respond appropriately to the LifeModel's public method names, because
they are called by the viewer, but you can implement them any way you
want, even using the LifeModel as a minimal adapter to a completely
different design. A LifeModel skeleton file is provided in the
lib/model directory for this purpose.

This software is located on GitHub at https://github.com/keithrbennett/life-game-viewer.

You can run it as follows: by rvm'ing to JRuby, cd'ing to the project's home directory,

```
rvm jruby
cd $LIFE_GAME_VIEWER_HOME  # wherever you've put it
lib/main.rb
```

It is also available via the standard gem repository, so you can just do:

You can also use it as a gem.  It will be made available on the standard
gem repository (if it is not already), or you can 'gem build' it
from the project root on the command line.

Then in your code (or in JRuby's irb) you can do:

```ruby
require 'life_game_viewer'
LifeGameViewer.new.view
```

