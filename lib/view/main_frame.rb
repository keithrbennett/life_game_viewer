require 'java'

require_relative '../model/life_visualizer'
require_relative 'clipboard_helper'

# Java Imports:
%w(
    java.awt.BorderLayout
    java.awt.Color
    java.awt.Dimension
    java.awt.Frame
    java.awt.GridLayout
    java.awt.Toolkit
    java.awt.datatransfer.DataFlavor
    java.awt.event.KeyEvent
    java.awt.event.WindowAdapter
    javax.swing.AbstractAction
    javax.swing.BorderFactory
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
    self.default_close_operation = JFrame::EXIT_ON_CLOSE
    add(JScrollPane.new(create_table(life_model)), BorderLayout::CENTER)
    add(create_header, BorderLayout::NORTH)
    add(create_bottom_panel, BorderLayout::SOUTH)
    get_content_pane.border = BorderFactory.create_empty_border(12, 12, 12, 12)
    addWindowListener(InitialFocusSettingWindowListener.new(@next_button))
    pack
  end

  # Change this to a java.awt.Dimension with different values
  # if you don't want the window to take up the whole screen.
  def getPreferredSize
    Toolkit.get_default_toolkit.screen_size
  end

  def create_table(life_model)
    @table_model = LifeTableModel.new_instance(life_model)
    table = JTable.new(@table_model)
    table.table_header = nil
    table.show_grid = true
    table.grid_color = Color::BLUE
    table.set_default_renderer(java.lang.Object, CellRenderer.new)
    table.row_height = 32
    table
  end

  def create_button(action_class, keystroke_text)
    action = action_class.send(:new, @table_model)
    button = JButton.new(action)
    key = KeyStroke.getKeyStroke(keystroke_text)
    button.get_input_map(JComponent::WHEN_IN_FOCUSED_WINDOW).put(key, keystroke_text)
    button.get_action_map.put(keystroke_text, action)
    button
  end

  def create_button_panel
    panel = JPanel.new(GridLayout.new(1, 0))

    panel.add(create_button(ShowFirstGenerationAction,    KeyEvent::VK_1))
    panel.add(create_button(ShowPreviousGenerationAction, KeyEvent::VK_4))
    @next_button = create_button(ShowNextGenerationAction, KeyEvent::VK_7)
    panel.add(@next_button)
    panel.add(create_button(ShowLastGenerationAction,     KeyEvent::VK_0))
    panel.add(create_button(CopyToClipboardAction,        ClipboardHelper.copy_key_name))
    panel.add(create_button(NewGameFromClipboardAction,   ClipboardHelper.paste_key_name))
    panel.add(create_button(ExitAction,                   KeyEvent::VK_Q))
    panel
  end

  def create_bottom_panel
    panel = JPanel.new(GridLayout.new(0, 1))
    panel.add(create_button_panel)
    panel.add(StatusLabel.new(@table_model))
    panel
  end

  def create_header
    # Use an inner FlowLayout panel embedded in the CENTER of a BorderLayout panel.
    inner_panel = JPanel.new
    label = JLabel.new(header_text)
    inner_panel.add(label)

    panel = JPanel.new(BorderLayout.new)
    panel.add(inner_panel, BorderLayout::CENTER)
    panel
  end

  def header_text
    "<html><h2>The Game of Life (#{@table_model.getRowCount} x #{@table_model.getColumnCount})</h2></html"
  end


  class ShowFutureGenerationAction < AbstractAction

    def initialize(table_model, next_or_last)
      @is_next = next_or_last == :next
      caption = @is_next \
          ? "Next Generation (7)"
          : "Last Generation (0)"
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
          ? "Previous Generation (4)"
          : "First Generation (1)"
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
      super("Copy to Clipboard (C)")
      put_value(SHORT_DESCRIPTION, "Press #{ClipboardHelper.key_prefix}-C to copy board contents to clipboard.")
      @table_model = table_model
    end

    def actionPerformed(event)
      LifeVisualizer.new.copy_to_clipboard(@table_model.life_model)
    end

  end

  class NewGameFromClipboardAction < AbstractAction

    def initialize(table_model)
      super("Paste New Game (V)")
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
        last_fragment = table_model.at_last_generation? ? " (Last)" : ""
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

