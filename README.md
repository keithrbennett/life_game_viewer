life_game_viewer
================

This is a JRuby application that uses Java's Swing UI library
to render generations of Conway's Game of Life.

My intention in writing it was to provide a GUI player
with which developers could view and test their implementations
of the Game of Life exercise.

In order to do the exercise, you will need to effectively replace the
LifeModel's implementation with your own.  However, you will need to
respond appropriately to the LifeModel's public methods, because
they are called by the viewer.

can use the LifeModel class, and delete
the implementations of all the nonpublic classes.  The public functions
there are required by the viewer, but you can implement them any way you
want, even using the LifeModel as a minimal adapter to a completely
different design.

It is located on GitHub at https://github.com/keithrbennett/life-game-viewer.

You can run it by rvm'ing to JRuby, cd'ing to the project's home directory,
and issuing the command lib/main.rb.

You can also use it as a gem (which you would naturally do if that is the
way you downloaded it).  To do that, do the following:

require 'life_game_viewer'
LifeGameViewer.new.view

In order to replace the back end functionality with your own,
reimplement the following methods in LifeModel:

# TODO
