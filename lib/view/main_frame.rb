require 'java'

# Java Imports:
%w(
    java.awt.BorderLayout
    java.awt.Color
    java.awt.Dimension
    java.awt.GridLayout
    javax.swing.AbstractAction
    javax.swing.ImageIcon
    javax.swing.JButton
    javax.swing.JFrame
    javax.swing.JLabel
    javax.swing.JPanel
    javax.swing.JScrollPane
    javax.swing.JTable
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
    pack
  end

  def create_table(life_model)
    @table_model = LifeTableModel.new_instance(life_model)
    table = JTable.new(@table_model)
    table.show_grid = true
    table.grid_color = Color::BLUE
    table.set_default_renderer(java.lang.Object, CellRenderer.new)
    table.row_height = 32
    table
  end

  def create_button_panel
    panel = JPanel.new(GridLayout.new(1, 0))
    panel.add(JButton.new(ShowFirstGenerationAction.new(@table_model)))
    panel.add(JButton.new(ShowPreviousGenerationAction.new(@table_model)))
    panel.add(JButton.new(ShowNextGenerationAction.new(@table_model)))
    panel.add(JButton.new(ShowLastGenerationAction.new(@table_model)))
    panel.add(JButton.new(ExitAction.new))
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

    def initialize(tableModel, next_or_last)
      @is_next = next_or_last == :next
      super("Show #{@is_next ? "Next" : "Last" } Generation")
      @table_model = tableModel
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

    def initialize(tableModel)
      super(tableModel, :next)
    end
  end


  class ShowLastGenerationAction < ShowFutureGenerationAction

    def initialize(tableModel)
      super(tableModel, :last)
    end
  end




  # Used for both previous and first generation buttons.
  class ShowPastGenerationAction < AbstractAction

    def initialize(tableModel, previous_or_first)
      @is_previous = previous_or_first == :previous
      super("Show #{@is_previous ? "Previous" : "First" } Generation")
      @table_model = tableModel
      @enabled_updater = lambda { |current_generation_num| self.enabled = ! @table_model.at_first_generation? }
      @table_model.add_current_num_change_handler(@enabled_updater)
      self.enabled = false  # we're already at the first generation
    end

    def actionPerformed(event)
      if (@is_previous)
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

    def initialize()
      super("Exit")
    end

    def actionPerformed(event)
      java.lang.System.exit(0)
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
      table_model.add_current_num_change_handler(@update_text)
    end
  end

  class LifeLabel < JLabel

    def initialize
      super
      self.horizontal_alignment = JLabel::CENTER
      self.vertical_alignment = JLabel::CENTER
      self.opaque = true
    end
  end


  class CellRenderer

    def initialize
      @label = LifeLabel.new
      image_spec = File.expand_path(File.join(
          File.dirname(__FILE__), '..', '..', 'resources', 'images', 'alfred-e-neuman.jpg'))
      @true_icon = ImageIcon.new(image_spec, 'Alfred E. Neuman')
    end

    # from TableCellRenderer interface
    def getTableCellRendererComponent(table, value, isSelected, hasFocus, row, column)
      alive = value
      @label.icon = alive ? @true_icon : nil
      @label.tool_tip_text = "row #{row}, column #{column}, value is #{alive}"
      @label
    end
  end
end