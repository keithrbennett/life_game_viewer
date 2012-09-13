require 'java'

java_import javax.swing.table.AbstractTableModel
java_import javax.swing.JOptionPane

require 'forwardable'

require_relative 'generations'

# This class is the model used to drive Swing's JTable.
# It contains a LifeModel to which it delegates most calls.
class LifeTableModel < AbstractTableModel

  extend Forwardable

  attr_accessor :life_model
  attr_reader :generations

  def_delegator :@life_model, :row_count,       :getRowCount
  def_delegator :@life_model, :column_count,    :getColumnCount
  def_delegator :@life_model, :number_living
  def_delegator :@life_model, :alive?,          :getValueAt

  def_delegator :@generations, :at_first_generation?
  def_delegator :@generations, :at_last_generation?

  def_delegator :@current_num_change_handlers, :<<, :add_current_num_change_handler

  def initialize(life_model)
    super()
    @current_num_change_handlers = []
    self.inner_model = life_model
  end

  def getColumnName(colnum)
    nil
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

  private

  def inner_model=(life_model)
    @life_model = life_model
    @generations = Generations.new(life_model)
  end

end


