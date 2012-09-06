# This file contains the definitions of all the Swing UI component
# classes.  The one containing all the rest is the MainFrame class.

require 'java'

require_relative '../model/life_visualizer'
require_relative 'clipboard_helper'

# Java Imports:
%w(
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
    javax.swing.AbstractAction
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
).each { |java_class| java_import(java_class)}


class MainFrame < JFrame

  attr_accessor :table_model

  def initialize(life_model)
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



class BottomPanel < JPanel
  def initialize(table_model, ancestor_window)
    super(GridLayout.new(0, 1))
    add(ButtonPanel.new(table_model, ancestor_window))
    add(Box.createVerticalStrut(1))
    add(BottomTextPanel.new(table_model))
  end
end


class BottomTextPanel < JPanel
  def initialize(table_model)
    super(BorderLayout.new(0, 1))

    github_label = HyperlinkLabel.new(
        'http://github.com/keithrbennett/life-game-viewer',
        "On Github")
    add(github_label, BorderLayout::WEST)

    add(StatusLabel.new(table_model), BorderLayout::CENTER)

    blog_label = HyperlinkLabel.new(
        'http://www.bbs-software.com/blog/2012/09/05/conways-game-of-life-viewer/',
        'Article')
    add(blog_label, BorderLayout::EAST)
  end
end



class HeaderPanel < JPanel
  def initialize
    super(BorderLayout.new)
    label = JLabel.new("<html><h2>Conway's Game of Life Viewer</h2></html")
    inner_panel = JPanel.new
    inner_panel.add(label)
    add(inner_panel, BorderLayout::CENTER)
  end
end



class Button < JButton
  def initialize(action_class, keystroke_text, table_model)
    action = action_class.send(:new, table_model)
    super(action)
    key = KeyStroke.getKeyStroke(keystroke_text)
    get_input_map(JComponent::WHEN_IN_FOCUSED_WINDOW).put(key, keystroke_text)
    get_action_map.put(keystroke_text, action)
  end
end



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



class ShowFutureGenerationAction < AbstractAction

  def initialize(table_model, next_or_last)
    @is_next = next_or_last == :next
    caption = @is_next \
        ? "Next (7)"
        : "Last (0)"
    super(caption)
    @table_model = table_model
    @enabled_updater = lambda { |current_generation_num| self.enabled = ! @table_model.at_last_generation? }
    @table_model.add_current_num_change_handler(@enabled_updater)
  end

  def actionPerformed(event)
    if @is_next
      @table_model.go_to_next_generation
    else
      @table_model.go_to_last_generation
    end
    @table_model.fire_table_data_changed
  end
end



class ShowNextGenerationAction < ShowFutureGenerationAction
  def initialize(table_model)
    super(table_model, :next)
  end
end



class ShowLastGenerationAction < ShowFutureGenerationAction
  def initialize(table_model)
    super(table_model, :last)
  end
end



# Used for both previous and first generation buttons.
class ShowPastGenerationAction < AbstractAction
  def initialize(table_model, previous_or_first)
    @is_previous = previous_or_first == :previous
    caption = @is_previous \
        ? "Previous (4)"
        : "First (1)"
    super(caption)

    @table_model = table_model
    @enabled_updater = lambda { |current_generation_num| self.enabled = ! @table_model.at_first_generation? }
    @table_model.add_current_num_change_handler(@enabled_updater)
    self.enabled = false  # we're already at the first generation
  end

  def actionPerformed(event)
    if @is_previous
      @table_model.go_to_previous_generation
    else
      @table_model.go_to_first_generation
    end
    @table_model.fire_table_data_changed
  end
end



class ShowPreviousGenerationAction < ShowPastGenerationAction
  def initialize(table_model)
    super(table_model, :previous)
  end
end



class ShowFirstGenerationAction < ShowPastGenerationAction
  def initialize(table_model)
    super(table_model, :first)
  end
end



class ExitAction < AbstractAction

  # table_model param not used but needed for instantiation by create_button
  def initialize(table_model)
    super("Exit (Q)")
    put_value(SHORT_DESCRIPTION, 'Press capital-Q to exit.')
  end

  def actionPerformed(event)
    java.lang.System.exit(0)
  end
end



class CopyToClipboardAction < AbstractAction

  def initialize(table_model)
    super("Copy (C)")
    put_value(SHORT_DESCRIPTION, "Press #{ClipboardHelper.key_prefix}-C to copy board contents to clipboard.")
    @table_model = table_model
  end

  def actionPerformed(event)
    text = LifeVisualizer.new.to_display_string(@table_model.life_model)
    ClipboardHelper.clipboard_text = text
  end
end



class NewGameFromClipboardAction < AbstractAction

  def initialize(table_model)
    super("Paste (V)")
    put_value(SHORT_DESCRIPTION, "Press #{ClipboardHelper.key_prefix}-V to create a new game from the clipboard contents.")
    @table_model = table_model
  end

  def actionPerformed(event)
    new_model = LifeModel.create_from_string(ClipboardHelper.clipboard_text)
    @table_model.reset_model(new_model)
  end
end



class StatusLabel < JLabel
  def initialize(table_model)
    super()
    @update_text = lambda do |current_generation_num|
      last_fragment = table_model.at_last_generation? ? " (last)" : ""
      self.text = "Current generation#{last_fragment}: #{current_generation_num}, Population: #{table_model.number_living}"
    end
    @update_text.call(0)
    self.horizontal_alignment = JLabel::CENTER
    table_model.add_current_num_change_handler(@update_text)
  end
end



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
        File.dirname(__FILE__), '..', '..', 'resources', 'images', 'alfred-e-neuman.jpg'))
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



class InitialFocusSettingWindowListener < WindowAdapter

  def initialize(component_requesting_focus)
    super()
    @component_requesting_focus = component_requesting_focus
  end

  def windowOpened(event)
    @component_requesting_focus.requestFocus
  end
end



class HyperlinkLabel < JLabel

  def initialize(url, caption)
    text = "<html><a href=#{url}>#{caption}</a></html>"  # make it appear like a hyperlink
    super(text)
    self.tool_tip_text = url
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


