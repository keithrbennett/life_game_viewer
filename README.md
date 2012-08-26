Game of Life Viewer
===================

(Note: These instructions assume use of a Unix command line (e.g. Linux, Mac OS) and rvm.
If you're using Windows, make the appropriate substitutions, such as '\' for '/', 'ren' for 'mv'.)

This is a JRuby application that uses Java's Swing UI library
to render generations of Conway's Game of Life.

My intention in writing it was to provide a GUI player
with which developers could view and test their implementations
of the Game of Life exercise.

Using it to View Your Own Game of Life Model Implementation
-----------------------------------------------------------

In order to do the exercise, you will need to effectively replace the
LifeModel's implementation with your own.  Your model will need to
respond appropriately to the LifeModel's public method names, because
they are called by the viewer, but you can implement them any way you
want, even using the LifeModel as a minimal adapter to a completely
different design. A LifeModel skeleton file is provided in the
lib/model directory for this purpose, so you can do the following:

```sh
cd $LIFE_GAME_VIEWER_HOME/lib  # wherever you've put it
mv LifeModel.rb LifeModelSample.rb
cp LifeModelSkeleton.rb LifeModel.rb
```

Where to Find This Software
---------------------------

This software is located on GitHub at https://github.com/keithrbennett/life-game-viewer.


How to Run This Software
------------------------

You can run it as follows:

```shell
rvm install jruby          # if not already installed and using rvm
rvm jruby                  # if necessary and using rvm
cd $LIFE_GAME_VIEWER_HOME  # wherever you've put it
lib/main.rb                # or jruby lib/main.rb if you're not using rvm
```

Reading and Writing Game Data
------------------------------------------------------

The application uses the system clipboard to read and write (i.e. load and save)
game data.  You use the same keys you would normally use for copying pasting;
that is, Command c and v on a Mac, and Ctrl c and v on other system.

Data is represented as follows:

* The data is a single string of lines, each line representing a row in the matrix
* Alive (true) values are represented as asterisks ('*'), and false values are hyphens.

For example, the two lines below:

```
*-
-*
```

...represents a 2 x 2 matrix in which only the upper left and
lower right cells were alive.  The final row's new line is optional.

When you copy a new game's data into the application, it clears all other data and
uses that as generation #0.

The clipboard functionality enables you to edit game data by doing the following:

* copy the game's current data into the clipboard 
* paste it into an editor window
* edit it
* 'select all' it
* copy it to your clipboard
* paste it back into the game

In many cases, it will be easier to generate the string programmatically, either in the program itself,
or in irb.


Using it as a Gem
-----------------

You can also use it as a gem by 'gem build'ing it 
from the project root on the command line. (it's not yet available
on RubyGems). Then in your code (or in JRuby's irb) you can do:

```ruby
require 'life_game_viewer'
LifeGameViewer.new.view
```

