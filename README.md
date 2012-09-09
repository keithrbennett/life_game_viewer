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


JRuby and Java
==============

This program will only run in [JRuby] [3] (which needs the Java Runtime Environment),
so you'll need to make sure you
have both installed.  The easiest way to install and use JRuby is with [rvm] [4],
which you
can only do with a Unix-like shell.  Linux or Mac OS will easily work; for Windows,
you might be able to get it to work with [Cygwin] [5].


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
Ruby code (I suggest using _irb_ to start):


```ruby
require 'life_game_viewer'
LifeGameViewer.view_sample
```

You can experiment with different data sets by:

1) using the clipboard copy and paste feature
(see _Reading and Writing Game Data Via the Clipboard_ below)

2) passing a custom model to the view function, e.g.:

```ruby
require 'life_game_viewer'
model = SampleLifeModel.create(5,5) { |r,c| r.even? } # as an example
LifeGameViewer.view(model)
```

3) (of course) modifying the source code



Viewing Your Own Game of Life Model Implementation
--------------------------------------------------

In order to do the exercise, you will need to replace the
[SampleLifeModel] [6] implementation with your own.  Your model will need to
respond appropriately to the SampleLifeModel's public method names, because
they are called by the viewer, but you can implement them any way you
want, even using the LifeModel as a minimal adapter to a completely
different design. (To take this to the extreme, the model could even
be implemented in Java, with a thin JRuby adapter around it; or, as
a RESTful web service in any arbitrary language with the adapter
making calls to it.)

A [MyLifeModel] [7] skeleton file is provided in the
lib/model directory as a convenient starting point for you.
You can copy this file into your own working area.


Where to Find This Software
---------------------------

This software is located on GitHub at
https://github.com/keithrbennett/life-game-viewer.
There is also an [article] [1] about this application on my [blog] [2].


Running the Sample from the Command Line
----------------------------------------

You can run it as follows.  Assuming the environment variable
_LIFE_GAME_VIEWER_HOME_ points to the root of the downloaded
or gem code base, you can do this:

```
$LIFE_GAME_VIEWER_HOME/lib/main.rb
```

If this doesn't work you may need to prepend _ruby_ or _jruby_
to this command line.


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

The most common problems will probably be related to the installation and use of JRuby,
and the unintentional use of MRI Ruby instead of JRuby.

To see which version of Ruby you're using, use the '-v' option for ruby or jruby:

```
>ruby -v
jruby 1.6.7 (ruby-1.9.2-p312) (2012-02-22 3e82bc8) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_33) [darwin-x86_64-java]
```

Another test is to try to require 'java'.  When you see the error in the last command below,
you know that you're not using JRuby:

```
>ruby -v
jruby 1.6.7 (ruby-1.9.2-p312) (2012-02-22 3e82bc8) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_33) [darwin-x86_64-java]

>ruby -e "require 'java'"

>rvm 1.9

>ruby -e "require 'java'"
/Users/keithb/.rvm/rubies/ruby-1.9.3-p125/lib/ruby/site_ruby/1.9.1/rubygems/custom_require.rb:36:
in `require': cannot load such file -- java (LoadError)
```


Feedback
--------

Constructive feedback is always welcome, even for little things.


License
-------

This software is released under the MIT/X11 license.


[1]: http://www.bbs-software.com/blog/2012/09/05/conways-game-of-life-viewer/   http://www.bbs-software.com/blog/2012/09/05/conways-game-of-life-viewer/
[2]: http://www.bbs-software.com/blog/     http://www.bbs-software.com/blog/
[3]: http://jruby.org/        http://jruby.org/
[4]: https://rvm.io/rvm/install/      https://rvm.io/rvm/install/
[5]: http://www.cygwin.com/       http://www.cygwin.com/
[6]: https://github.com/keithrbennett/life-game-viewer/blob/master/lib/model/sample_life_model.rb     https://github.com/keithrbennett/life-game-viewer/blob/master/lib/model/sample_life_model.rb
[7]: https://github.com/keithrbennett/life-game-viewer/blob/master/lib/model/my_life_model.rb     https://github.com/keithrbennett/life-game-viewer/blob/master/lib/model/my_life_model.rb
