Game of Life Viewer
===================

This is a JRuby application that calculates and displays generations
of Conway's Game of Life.
It uses Java's Swing UI library and is an entirely client side application,
so there is no need for a web server, browser, or even network connection.

The game itself (as opposed to the viewer) is often used as a programming
exercise.  More information on the game is at
http://en.wikipedia.org/wiki/Conway%27s_Game_of_Life.

My intention in writing this was to provide a GUI player
with which developers could

<ol>
<li> view and test their implementations of the Game of Life exercise</li>
<li> easily inspect the results of different data inputs into the game</li>
</ol>


JRuby and Java
==============

This program will only run in JRuby (which needs the Java Runtime Environment),
so you'll need to make sure you
have both installed.  The easiest way to install and use JRuby is with rvm, which you
can only do with a Unix-like shell.  Linux or Mac OS will easily work; for Windows,
you might be able to get it to work with Cygwin.


1.9 Required
============

This program requires that JRuby be run in 1.9 mode.  In JRuby versions 1.7
and above, this is the default setting, but for earlier versions
you'll have to specify this mode by passing the "--1.9" option to JRuby.
It's probably easiest to do this by putting the following into your startup shell:

```
export JRUBY_OPTS=--1.9
```

You could also do this on your command line by preceding your JRuby commands with
the setting, as in:

```
JRUBY_OPTS=--1.9 jruby ...
```


Instructions
============

(Note: These instructions assume use of a Unix command line
(e.g. Linux, Mac OS) and rvm. If you're using Windows,
make the appropriate substitutions, such as '\' for '/', 'ren' for 'mv'.
Also, please see the troubleshooting section below if you have
problems running the program.)

It's fine to use a downloaded copy of the source tree directly,
but using it as a gem will probably be simpler.

Here is how to run it with the provided model and provided sample data.
First, install the life-game-viewer gem.  Then in your
Ruby code (I suggest using irb to start):


```ruby
require 'life_game_viewer'
LifeGameViewer.view_sample
```

You can experiment with different data sets by:

1) using the clipboard copy and paste feature
(see "Reading and Writing Game Data Via the Clipboard" below)

2) passing a custom model to the view function

```ruby
require 'life_game_viewer'
model = SampleLifeModel.create(5,5) { |r,c| r.even? } # as an example
LifeGameViewer.view(model)
```

3) (of course) modifying the source code



Using it to View Your Own Game of Life Model Implementation
-----------------------------------------------------------

In order to do the exercise, you will need to replace the
SampleLifeModel's implementation with your own.  Your model will need to
respond appropriately to the SampleLifeModel's public method names, because
they are called by the viewer, but you can implement them any way you
want, even using the LifeModel as a minimal adapter to a completely
different design. (To take this to the extreme, the model could even
be implemented in Java, with a thin JRuby adapter around it.)

A MyLifeModel skeleton file is provided in the
lib/model directory as a convenient starting point for you.
You can copy this file into your own working area.


Where to Find This Software
---------------------------

This software is located on GitHub at
https://github.com/keithrbennett/life-game-viewer.
There is also a blog article about this application at
http://www.bbs-software.com/blog/2012/09/05/conways-game-of-life-viewer/.


Running the Sample from the Command Line
----------------------------------------

You can run it as follows.  Assuming the environment variable
LIFE_GAME_VIEWER_HOME points to the root of the downloaded
or gem code base, you can do this:

```
$LIFE_GAME_VIEWER_HOME/lib/main.rb
```

If this doesn't work you may need to prepend "ruby" or "jruby"
to this command line.


Reading and Writing Game Data Via the Clipboard
-----------------------------------------------

The application starts with a sample data set that can be easily modified in the code.
You can also use the provided buttons to use the system clipboard to load and save
game data.  You use the same keys you would normally use for copying pasting,
that is, Command c and v on a Mac, and Ctrl c and v on other system.

Data is represented as follows:

* The data is a single string of lines, each line representing a row in the matrix
* Alive (true) values are represented as asterisks ('*'), and false values are hyphens.

For example, the two lines below:

```
*-
-*
```

...represent a 2 x 2 matrix in which only the upper left and
lower right cells are alive.  The final row's new line is optional.

When you copy a new game's data into the application, it clears all other data and
uses that as generation #0.

The clipboard functionality enables you to edit game data by doing the following:

* copy the game's current data into the clipboard 
* paste it into an editor window
* edit it
* 'select all' it
* copy it to your clipboard
* paste it back into the game

In many cases, it will be easier to generate the string programmatically,
either in the program itself, or in irb.



License
-------

This software is released under the MIT/X11 license.
