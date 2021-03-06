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
with which developers could:

<ol>
<li> view and test their implementations of the Game of Life exercise</li>
<li> easily inspect the results of different data inputs into the game</li>
</ol>

(Note: The instructions below assume use of a Unix command line
(e.g. Linux, Mac OS) and rvm. If you're using Windows,
make the appropriate substitutions, such as 'jruby' for 'ruby',
'\' for '/', 'ren' for 'mv', and 'set' for 'export'.
Also, please see the troubleshooting section below if you have
problems running the program.)


JRuby and Java
==============

This program will only run in [JRuby] [3],which needs the Java Runtime Environment,
so you'll need to make sure you have both installed.
The easiest way to install and use JRuby is with [rvm] [4], which you
can only do with a Unix-like shell.  Linux or Mac OS will easily work; for Windows,
you might be able to get it to work with [Cygwin] [5].


1.9 Required
============

This program requires that JRuby be run in 1.9 mode.  In JRuby versions 1.7
and above, this is the default setting, but for earlier versions
you'll have to specify this mode by passing the _--1.9_ option to JRuby.
Here are three ways to do that:

1) put the following into your startup
shell's initialization file (e.g. .bashrc or .zshrc):

```
export JRUBY_OPTS=--1.9
```

2) execute the above command in your shell

3) precede the command with the variable/value setting, e.g.:

You could do this for just the one command on your command line instead by preceding your JRuby commands with
the setting, as in:

```
JRUBY_OPTS=--1.9 irb               # or
JRUBY_OPTS=--1.9 jruby             # or
JRUBY_OPTS=--1.9 life_view_sample
```


Running With the Provided Sample Model
--------------------------------------

It's fine to use a downloaded copy of the source tree directly,
but using it as a gem will probably be simpler.

Here is how to run it with the provided model and provided sample data.
First, install the life_game_viewer gem. This installs a script that
you can then run on your command line:

```
life_view_sample
```

You can experiment with different data sets by:

1) using the clipboard copy and paste feature
(see _Reading and Writing Game Data Via the Clipboard_ below)

2) instantiating a model yourself, e.g.:

```ruby
require 'life_game_viewer'
model = SampleLifeModel.create(5,5) { |r,c| r.even? } # as an example
LifeGameViewer::Main.view(model)
```

3) (of course) modifying the source code



Viewing Your Own Game of Life Model Implementation
--------------------------------------------------

In order to do the exercise, you will need to replace the
[SampleLifeModel] [6] implementation with your own.  Your model will need to
respond appropriately to the SampleLifeModel's public method names, because
they are called by the viewer, but you can implement them any way you
want, even using your MyLifeModel as a minimal adapter to a completely
different design. (To take this to the extreme, the model could even
be implemented in Java, with a thin JRuby adapter around it; or, as
a RESTful web service in any arbitrary language with the adapter
making calls to it.)

A [MyLifeModel] [7] skeleton file is provided in the
lib/life_game_viewer/model directory as a convenient starting point for you.
You can copy this file into your own working area.

In your program, all you would need to do is to require life_game_viewer
and pass an instance of your model to the LifeGameViewer.view method.
For example:

```ruby
require 'life_game_viewer'
model = MyLifeModel.create(5,5) { |r,c| r.even? } # as an example
LifeGameViewer::Main.view(model)
```


Where to Find This Software
---------------------------

This software is located on GitHub at
https://github.com/keithrbennett/life_game_viewer.
There is also an [article] [1] about this application on my [blog] [2].


Reading and Writing Game Data Via the Clipboard
-----------------------------------------------

The application starts with a sample data set that can be easily modified in the code.
You can also use the provided buttons to use the system clipboard to load and save
game data.  You use the same keys you would normally use for copying pasting,
that is, _Command_ c and v on a Mac, and _Ctrl_ c and v on other systems. (Note: there
are currently problems using these keystrokes on Linux and Windows; for now,
please click the buttons.)

Data is represented as follows:

* The data is a single string of lines, each line representing a row in the matrix
* Alive (true) values are represented as asterisks ('*'), and false values are hyphens ('-').

For example, the two lines below:

```
*-
-*
```

...represent a 2 x 2 matrix in which only the upper left and
lower right cells are alive.  The final row's new line is optional.

When you copy a new game's data into the application, it clears all other data and
uses the new data as generation #0.

The clipboard functionality enables you to edit game data by doing the following:

* copy the game's current data into the clipboard 
* paste it into an editor window
* edit it
* 'select all' it
* copy it to your clipboard
* paste it back into the game

In many cases, it will be easier to generate the string programmatically,
either in the program itself, or in irb.


Navigating the Generations
--------------------------

There are buttons to help you navigate the generations:
_First_, _Previous_, _Next_, and _Last_.
There are keystroke equivalents for your convenience, all numbers
so that you can put your fingers on the number row of the
keyboard to do all your navigation. The numbers _1_, _4_, _7_, and _0_
correspond to _First_, _Previous_, _Next_, and _Last_, respectively.

The Game of Life next generation calculation algorithm
only considers the most recent generation as input, so
if there are two consecutive generations that are identical,
all subsequent ones will be identical as well.  The viewer will
consider the first of consecutive identical generations to be
the end of the lineage.

You can have the viewer find this last generation for you
by pressing the _Last_ button.  Be careful, though --
this operation runs on the main UI thread and I haven't
gotten around to enabling its interruption --
so be prepared to kill the application if it no longer responds.
You can normally do this by pressing _Ctrl-C_ on the command line
from which you started the program.


Troubleshooting
---------------

The most common problems will probably be that you are using MRI ruby
rather than JRuby, or be in 1.8 rather than 1.9 mode.

To see which version of Ruby you're using, use the '-v' option for ruby or jruby, and
note whether the beginning of the line contains _ruby_ or _jruby_:

```
>ruby -v
jruby 1.6.7 (ruby-1.9.2-p312) (2012-02-22 3e82bc8) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_33) [darwin-x86_64-java]
```

To see which Ruby version mode JRuby is using you can do this:

```
>ruby -e "puts RUBY_VERSION"
1.9.2
```


Feedback
--------

Constructive feedback is always welcome, even for little things.


License
-------

This software is released under the MIT/X11 license.


[1]: http://www.bbs-software.com/blog/2012/09/05/conways-game-of-life-viewer/   "http://www.bbs-software.com/blog/2012/09/05/conways-game-of-life-viewer/"
[2]: http://www.bbs-software.com/blog/     "http://www.bbs-software.com/blog/"
[3]: http://jruby.org/        "http://jruby.org/"
[4]: https://rvm.io/rvm/install/      "https://rvm.io/rvm/install/"
[5]: http://www.cygwin.com/       "http://www.cygwin.com/"
[6]: https://github.com/keithrbennett/life_game_viewer/blob/master/lib/life_game_viewer/model/sample_life_model.rb     "https://github.com/keithrbennett/life_game_viewer/blob/master/lib/life_game_viewer/model/sample_life_model.rb"
[7]: https://github.com/keithrbennett/life_game_viewer/blob/master/lib/life_game_viewer/model/my_life_model.rb     "https://github.com/keithrbennett/life_game_viewer/blob/master/lib/life_game_viewer/model/my_life_model.rb"
