require 'java'
java_import javax.swing.table.AbstractTableModel


class LifeTableModel < AbstractTableModel

  attr_accessor :life_model
  attr_accessor :generations  # array of LifeModel's
  attr_accessor :current_generation_num

  def self.new_instance(life_model)
    instance = LifeTableModel.new
    instance.life_model = life_model
    instance.generations = [life_model]
    instance.current_generation_num = 0
    instance
  end

  #def initialize(life_model)
  #  super
  #  @life_model = life_model
  #end

  def getRowCount
    life_model.row_count
  end

  def getColumnCount
    life_model.column_count
  end

  def getValueAt(row, col)
    alive = life_model.alive?(row, col)
    alive ? '*' : '-'
  end

  def go_to_next_generation
    next_generation_num = current_generation_num + 1
    next_generation_is_cached = next_generation_num < generations.size
    unless next_generation_is_cached
      generations << life_model.next_generation_model
    end
    self.life_model = generations[next_generation_num]
    self.current_generation_num = next_generation_num
  end

end