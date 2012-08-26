Game of Life Viewer
===================

This is a JRuby application that uses Java's Swing UI library
to render generations of Conway's Game of Life.

My intention in writing it was to provide a GUI player
with which developers could view and test their implementations
of the Game of Life exercise.

Using it to View Your Own Game of Life Model Implementation
-----------------------------------------------------------

In order to do the exercise, you will need to effectively replace the
LifeModel's implementation with your own.  You will need to
respond appropriately to the LifeModel's public method names, because
they are called by the viewer, but you can implement them any way you
want, even using the LifeModel as a minimal adapter to a completely
different design. A LifeModel skeleton file is provided in the
lib/model directory for this purpose.

Where to Find This Software
---------------------------

This software is located on GitHub at https://github.com/keithrbennett/life-game-viewer.


How to Run This Software
------------------------

You can run it as follows:

```bash
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

...pasted from your clipboard would represent a 2 x 2 matrix in which only the upper left and
lower right cells were alive.  The final row's new line is optional.

When you copy a new game's data into the application, it clears all other data and
uses that as generation #0.

Note: I'm currently working on a bug with the clipboard keystrokes -- the buttons don't
receive the events if a button hasn't already been clicked.  If the keystroke
doesn't work, click the button.

Using it as a Gem
-----------------

You can also use it as a gem by 'gem build'ing it 
from the project root on the command line. (it's not yet available
on RubyGems). Then in your code (or in JRuby's irb) you can do:

```ruby
require 'life_game_viewer'
LifeGameViewer.new.view
```

