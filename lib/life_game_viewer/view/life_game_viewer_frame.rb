# This file contains the definitions of all the Swing UI component
# classes.  The one containing all the rest is the MainFrame class.

require 'java'

require_relative '../model/life_visualizer'
require_relative '../model/model_validation'
require_relative '../model/sample_life_model'
require_relative 'life_table_model'
require_relative 'actions'


# Java Imports:
java_import %w(
    java.awt.BorderLayout
    java.awt.Color
    java.awt.Desktop
    java.awt.Dimension
    java.awt.Frame
    java.awt.GridLayout
    java.awt.Toolkit
    java.awt.event.KeyEvent
    java.awt.event.MouseAdapter
    java.awt.event.WindowAdapter
    java.net.URI
    javax.swing.BorderFactory
    javax.swing.Box
    javax.swing.ImageIcon
    javax.swing.JButton
    javax.swing.JComponent
    javax.swing.JFrame
    javax.swing.JLabel
    javax.swing.JPanel
    javax.swing.JScrollPane
    javax.swing.JTable
    javax.swing.KeyStroke
    javax.swing.UIManager
    javax.swing.table.TableCellRenderer
)


class LifeGameViewerFrame < JFrame

  attr_accessor :table_model

  # Special class method for demonstration purposes; makes it
  # trivially simple to view the program in action without
  # having to add any custom behavior.
  def self.view_sample
    str = ''
    12.times { str << ('*-' * 6) << "\n" }
    model = SampleLifeModel.create_from_string(str)
    frame = LifeGameViewerFrame.new(model)
    frame.visible = true
    frame  # return frame so it can be manipulated (.visible =, etc.)
  end

  def initialize(life_model)
    model_validation_message = ModelValidation.new.methods_missing_message(life_model)
    if model_validation_message
      raise model_validation_message
    end

    super('The Game of Life')
    @table_model = LifeTableModel.new(life_model)
    self.default_close_operation = JFrame::EXIT_ON_CLOSE
    add(JScrollPane.new(Table.new(table_model)), BorderLayout::CENTER)
    add(HeaderPanel.new, BorderLayout::NORTH)
    add(BottomPanel.new(@table_model, self), BorderLayout::SOUTH)
    content_pane.border = BorderFactory.create_empty_border(12, 12, 12, 12)
    pack
  end

  # This is the method that Swing will call to ask what size to
  # attempt to set for this window.
  def getPreferredSize
    # use the default size calculation; this would of course also be accomplished
    # by not implementing the method at all.
    super

    # Or, you can override it with specific pixel sizes (width, height)
    # Dimension.new(700, 560)

    # Or, use the line below to make it the full screen size:
    # Toolkit.get_default_toolkit.screen_size
  end
end



# The application's table, containing alive/dead board values.
class Table < JTable
  def initialize(table_model)
    super(table_model)
    self.table_header = nil
    self.show_grid = true
    self.grid_color = Color::BLUE
    set_default_renderer(java.lang.Object, CellRenderer.new)
    self.row_height = 32
  end
end



# Combines button panel and bottom text panel into a single panel.
class BottomPanel < JPanel
  def initialize(table_model, ancestor_window)
    layout = GridLayout.new(0, 1)
    super(layout)
    layout.vgap = 12
    add(ButtonPanel.new(table_model, ancestor_window))
    add(StatusAndLinksPanel.new(table_model))
  end
end


# Panel for top of main application window containing a large title.
class HeaderPanel < JPanel
  def initialize
    super(BorderLayout.new)
    label = JLabel.new("<html><h2>Conway's Game of Life Viewer</h2></html")
    inner_panel = JPanel.new
    inner_panel.add(label)
    add(inner_panel, BorderLayout::CENTER)
  end
end


# Subclassed by application buttons, contains their common functionality
# added to the Swing JButton class.
class Button < JButton
  def initialize(action_class, keystroke_text, table_model)
    action = action_class.new(table_model)
    super(action)
    key = KeyStroke.getKeyStroke(keystroke_text)
    get_input_map(JComponent::WHEN_IN_FOCUSED_WINDOW).put(key, keystroke_text)
    get_action_map.put(keystroke_text, action)
  end
end


# Panel containing horizontal row of buttons.
class ButtonPanel < JPanel
  def initialize(table_model, ancestor_window)
    super(GridLayout.new(1, 0))
    add(Button.new(ShowFirstGenerationAction, KeyEvent::VK_1, table_model))
    add(Button.new(ShowPreviousGenerationAction, KeyEvent::VK_4, table_model))

    next_button = Button.new(ShowNextGenerationAction, KeyEvent::VK_7, table_model)
    add(next_button)
    ancestor_window.add_window_listener(InitialFocusSettingWindowListener.new(next_button))

    add(Button.new(ShowLastGenerationAction,     KeyEvent::VK_0, table_model))
    add(Button.new(CopyToClipboardAction,        ClipboardHelper.copy_key_name, table_model))
    add(Button.new(NewGameFromClipboardAction,   ClipboardHelper.paste_key_name, table_model))
    add(Button.new(ExitAction,                   KeyEvent::VK_Q, table_model))
  end
end



# Status label showing, e.g. "Current Generation: 1, Population: 42"
class StatusLabel < JLabel
  def initialize(table_model)
    super()
    @update_text = lambda do |current_generation_num|
      last_fragment = table_model.at_last_generation? ? " (last)" : ""
      self.text = "Current Generation#{last_fragment}: #{current_generation_num}, Population: #{table_model.number_living}"
    end
    @update_text.call(0)
    self.horizontal_alignment = JLabel::CENTER
    table_model.add_current_num_change_handler(@update_text)
  end
end


# This class is responsible for rendering the display of a table cell,
# which in our case is to display an image of Alfred E. Neuman if the
# underlying data value is true, else display nothing.
class CellRenderer

  class LifeLabel < JLabel
    def initialize
      super
      self.horizontal_alignment = JLabel::CENTER
      self.vertical_alignment = JLabel::CENTER
      self.opaque = true
    end
  end

  def initialize
    @label = LifeLabel.new
    image_spec = File.expand_path(File.join(
        File.dirname(__FILE__), '..', '..', '..', 'resources', 'images', 'alfred-e-neuman.jpg'))
    @true_icon = ImageIcon.new(image_spec, 'Alfred E. Neuman')
  end

  # from TableCellRenderer interface
  def getTableCellRendererComponent(table, value, is_selected, has_focus, row, column)
    alive = value
    @label.icon = alive ? @true_icon : nil
    @label.tool_tip_text = "row #{row}, column #{column}, value is #{alive}"
    @label
  end
end


# When added as a listener to a given window, will cause the
# passed component to own focus when the window first opens.
class InitialFocusSettingWindowListener < WindowAdapter

  def initialize(component_requesting_focus)
    super()
    @component_requesting_focus = component_requesting_focus
  end

  def windowOpened(event)
    @component_requesting_focus.requestFocus
  end
end



# JLabel that a) provides a clickable link that launches the default browser
# with the passed URL, b) makes the text appear like a hyperlink, and
# c) sets the tooltip text to be the URL.
class HyperlinkLabel < JLabel

  def initialize(url, caption, tool_tip_text)
    text = "<html><a href=#{url}>#{caption}</a></html>"  # make it appear like a hyperlink
    super(text)
    self.tool_tip_text = tool_tip_text
    add_mouse_listener(ClickAdapter.new(url))
  end

  class ClickAdapter < MouseAdapter

    def initialize(url)
      super()
      @url = url
    end

    def mouseClicked(event)
      Desktop.desktop.browse(URI.new(@url))
    end
  end
end


class LinkPanel < JPanel

  def initialize

    #Without the call to super below, I get the following error:
    #RuntimeError: Java wrapper with no contents: LinkPanel
    #see http://jira.codehaus.org/browse/JRUBY-4704; not fixed?
    super

    add(wikipedia_label)
    add(JLabel.new(" | "))
    add(github_label)
    add(JLabel.new(" | "))
    add(article_label)
  end

  def wikipedia_label
    url = 'http://en.wikipedia.org/wiki/Conway%27s_Game_of_Life'
    HyperlinkLabel.new(url, "Wikipedia",
        "Visit Conway's Game of Life page on Wikipedia at #{url}.")
  end

  def github_label
    url = 'http://github.com/keithrbennett/life_game_viewer'
    HyperlinkLabel.new(url, "Github",
        "Visit the Github page for this project at #{url}.")
  end

  def article_label
    url = 'http://www.bbs-software.com/blog/2012/09/05/conways-game-of-life-viewer/'
    HyperlinkLabel.new(url, "Article",
        "Visit the blog article about this project at #{url}.")
  end
end



class StatusAndLinksPanel < JPanel
  def initialize(table_model)
    super(BorderLayout.new)
    add(StatusLabel.new(table_model), BorderLayout::WEST)
    add(LinkPanel.new, BorderLayout::EAST)
  end
end