require 'java'

java_import 'java.awt.BorderLayout'
java_import 'java.awt.GridLayout'
java_import 'javax.swing.AbstractAction'
java_import 'javax.swing.JButton'
java_import 'javax.swing.JFrame'
java_import 'javax.swing.JLabel'
java_import 'javax.swing.JPanel'
java_import 'javax.swing.JTable'


class MainFrame < JFrame

  attr_accessor :table_model

  def initialize(life_model)
    super('The Game of Life')
    set_default_close_operation(JFrame::EXIT_ON_CLOSE)
    @table_model = LifeTableModel.new_instance(life_model)
    table = JTable.new(@table_model)
    add(header, BorderLayout::NORTH)
    add(table, BorderLayout::CENTER)
    add(button_panel, BorderLayout::SOUTH)
    pack
  end

  def button_panel
    panel = JPanel.new(GridLayout.new(1, 0))
    panel.add(JButton.new(ShowNextGenerationAction.new(@table_model)))
    panel.add(JButton.new(ExitAction.new))
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
      @table_model = tableModel;
    end

    def show_next_generation
      @table_model.go_to_next_generation
      @table_model.fire_table_data_changed
    end

    def action_performed(event)
      show_next_generation
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

end