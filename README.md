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
different design. A LifeModel skeleton is provided for this purpose.

This software is located on GitHub at https://github.com/keithrbennett/life-game-viewer.

You can run it by rvm'ing to JRuby, cd'ing to the project's home directory,
and issuing the command lib/main.rb.

It is also available via the standard gem repository, so you can just do:

You can also use it as a gem (which you would naturally do if that is the
way you downloaded it). You can either the standard gem repository
(TODO: put it there), or do a gem build *gemspec from the project root,
and then gem install that file.

Then in your code (or in JRuby's irb) you can do:

require 'life_game_viewer'
LifeGameViewer.new.view
