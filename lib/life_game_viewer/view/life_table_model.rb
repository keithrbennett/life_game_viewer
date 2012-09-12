require 'java'

java_import javax.swing.table.AbstractTableModel
java_import javax.swing.JOptionPane

require_relative 'generations'

# This class is the model used to drive Swing's JTable.
# It contains a LifeModel to which it delegates most calls.
class LifeTableModel < AbstractTableModel

  attr_accessor :life_model
  attr_reader :generations


  def initialize(life_model)
    super()
    @current_num_change_handlers = []
    self.inner_model = life_model
  end

  def inner_model=(life_model)
    @life_model = life_model
    @generations = Generations.new(life_model)
  end

  def getRowCount
    life_model.row_count
  end

  def getColumnCount
    life_model.column_count
  end

  def getValueAt(row, col)
    life_model.alive?(row, col)
  end

  def getColumnName(colnum)
    nil
  end

  def at_first_generation?
    generations.at_first_generation?
  end

  def at_last_generation?
    generations.at_last_generation?
  end

  def number_living
    life_model.number_living
  end

  def go_to_next_generation
    if at_last_generation?
      JOptionPane.show_message_dialog(nil, "Generation ##{generations.current_num} is the last non-repeating generation.")
    else
      self.life_model = generations.next
      fire_current_number_changed
    end
  end

  def go_to_previous_generation
    raise "Should not have gotten here; already at first generation" if at_first_generation?
    self.life_model = generations.previous
    fire_current_number_changed
  end

  def go_to_first_generation
    self.life_model = generations.first
    fire_current_number_changed
  end

  def go_to_last_generation
    self.life_model = generations.last
    fire_current_number_changed
  end

  def add_current_num_change_handler(callable)
    @current_num_change_handlers << callable
  end

  def reset_model(new_model)
    self.inner_model = new_model
    fire_table_structure_changed
    fire_current_number_changed
  end

  def fire_current_number_changed
    @current_num_change_handlers.each do |handler|
      handler.call(generations.current_num)
    end
  end
end

