require 'java'

java_import 'java.awt.BorderLayout'
java_import 'java.awt.Color'
java_import 'java.awt.Dimension'
java_import 'java.awt.GridLayout'
java_import 'javax.swing.AbstractAction'
java_import 'javax.swing.ImageIcon'
java_import 'javax.swing.JButton'
java_import 'javax.swing.JFrame'
java_import 'javax.swing.JLabel'
java_import 'javax.swing.JPanel'
java_import 'javax.swing.JScrollPane'
java_import 'javax.swing.JTable'
java_import 'javax.swing.table.TableCellRenderer'


class MainFrame < JFrame

  attr_accessor :table_model

  def initialize(life_model)
    super('The Game of Life')
    self.default_close_operation = JFrame::EXIT_ON_CLOSE

    @table_model = LifeTableModel.new_instance(life_model)
    table = JTable.new(@table_model)
    table.show_grid = true
    table.grid_color = Color::BLUE
    table.set_default_renderer(java.lang.Object, CellRenderer.new)
    table.row_height = 32

    add(header, BorderLayout::NORTH)
    add(JScrollPane.new(table), BorderLayout::CENTER)
    add(bottom_panel, BorderLayout::SOUTH)

    pack
  end

  def button_panel
    panel = JPanel.new(GridLayout.new(1, 0))
    panel.add(JButton.new(ShowPreviousGenerationAction.new(@table_model)))
    panel.add(JButton.new(ShowNextGenerationAction.new(@table_model)))
    panel.add(JButton.new(ExitAction.new))
    panel
  end

  def bottom_panel
    panel = JPanel.new(GridLayout.new(0, 1))
    panel.add(button_panel)
    panel.add(StatusLabel.new_instance(@table_model))
    panel
  end

  def header
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


  class ShowNextGenerationAction < AbstractAction

    def initialize(tableModel)
      super("Show Next Generation")
      @table_model = tableModel
    end

    def show_next_generation
      @table_model.go_to_next_generation
      @table_model.fire_table_data_changed
    end

    def actionPerformed(event)
      show_next_generation
    end
  end


  class ShowPreviousGenerationAction < AbstractAction

    def initialize(tableModel)
      super("Show Previous Generation")
      @table_model = tableModel
      @enabled_updater = lambda { |current_generation_num| self.enabled = current_generation_num > 0 }
      @table_model.add_current_num_change_handler(@enabled_updater)
      self.enabled = false  # we're already at the first generation
    end

    def show_previous_generation
      @table_model.go_to_previous_generation
      @table_model.fire_table_data_changed
    end

    def actionPerformed(event)
      show_previous_generation
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

    def self.new_instance(table_model)
      instance = StatusLabel.new
      instance.init(table_model)
      instance
    end

    def init(table_model)
      @update_text = lambda { |current_generation_num| self.text = "Current generation: #{current_generation_num}" }
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
      @true_icon = ImageIcon.new('../images/alfred-e-neuman.jpg', 'Alfred E. Neuman')
    end

    # from TableCellRenderer interface
    def getTableCellRendererComponent(table, value, isSelected, hasFocus, row, column)
      alive = (value == '*')
      @label.icon = alive ? @true_icon : nil
      @label.tool_tip_text = "row #{row}, column #{column}, value is #{alive}"
      @label
    end
  end
end