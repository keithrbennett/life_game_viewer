life_game_viewer
================

This is a JRuby application that uses Java's Swing UI library
to render generations of Conway's Game of Life.

My intention in writing it was to provide a GUI player
with which developers could view and test their Game of Life implementations.

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
