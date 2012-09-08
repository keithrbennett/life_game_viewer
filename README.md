Game of Life Viewer
===================

This is a JRuby application that uses Java's Swing UI library
to render generations of Conway's Game of Life.  More information
on the game is at http://en.wikipedia.org/wiki/Conway%27s_Game_of_Life.

My intention in writing it was to provide a GUI player application
with which developers could view and test their implementations
of the Game of Life exercise, and experiment with game data.

(Note: These instructions assume use of a Unix command line
(e.g. Linux, Mac OS) and rvm.  You will need to rvm install jruby
and then rvm use jruby so that JRuby commands are available
using the names of their MRI equivalents.

If you're using Windows, make the appropriate substitutions,
such as 'jruby' for 'ruby', '\' for '/', 'ren' for 'mv'.)


Using It As A Gem
-----------------

I have not yet been able to get it onto the RubyGems repo, but meanwhile
you can clone or download the source and do this (assumes that the
LIFE_GAME_VIEWER_HOME environment variable points to the root
of life-game-viewer):

```ruby
cd $LIFE_GAME_VIEWER_HOME
gem build *gemspec
gem install *gem
```
(Replace the 'gem' command above with 'jruby -S gem' if not using rvm.)

Then you can run the following, e.g. in irb:

```ruby
require 'life_game_viewer'
LifeGameViewer.new.view
```

This can be done in a single command with:

```
ruby -e "require 'life_game_viewer'; LifeGameViewer.new.view"
```

If you implement your own model, then you can pass an instance of it to
the view method:

```ruby
# my_model_instance = MyModel.create ...
LifeGameViewer.new.view(my_model_instance)
```


Running it Directly From Source
-------------------------------


You can run it as follows:

```
rvm install jruby          # if not already installed and using rvm
rvm jruby                  # if necessary and using rvm
cd $LIFE_GAME_VIEWER_HOME  # wherever you've put it
lib/main.rb                # or jruby lib/main.rb if you're not using rvm
```


Using it to View Your Own Game of Life Model Implementation
-----------------------------------------------------------

In order to do the exercise, you will need to effectively replace the
LifeModel's implementation with your own.  Your model will need to
respond appropriately to the LifeModel's public method names, because
they are called by the viewer, but you can implement them any way you
want, even using the LifeModel as a minimal adapter to a completely
different design. A LifeModel skeleton file is provided in the
lib/model directory for this purpose.

For example, assuming you have installed Life Game Viewer as a gem,
and you have implemented a MyLifeModel class, you could do:

```ruby
require 'life_game_viewer'
model = MyLifeModel.create(12, 12) { |r,c| r.even? }
LifeGameViewer.new.view(model)
```

If there are any methods missing from your model implementation,
an exception will be raised.  Its message will contain the
names of the missing methods.


Where to Find This Software
---------------------------

This software is located on GitHub at https://github.com/keithrbennett/life-game-viewer.




Reading and Writing Game Data
------------------------------------------------------

The application starts with a sample data set that can be easily modified in the code.
You can also use the provided buttons to use the system clipboard to load and save
game data.  You use the same keys you would normally use for copying and pasting,
that is, Command c and v on a Mac, and Ctrl c and v on other systems.

Data is represented as follows:

* The data is a single string of lines, each line representing a row in the matrix
* Alive (true) values are represented as asterisks ('*'), and false values are hyphens.

For example, the two lines below:

```
*-
-*
```

...represent a 2 x 2 matrix in which only the upper left and
lower right cells are alive.  The final row's new line character is optional.

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


License
-------

This software is released under the MIT/X11 license.
