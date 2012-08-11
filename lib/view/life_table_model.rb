require 'java'
java_import javax.swing.table.AbstractTableModel


class LifeTableModel < AbstractTableModel

  attr_accessor :life_model
  attr_reader :generations  # array of LifeModel's
  attr_reader :current_generation_num

  # This is necessary because of a JRuby bug -- if a Ruby class
  # with a 1-arg constructor subclasses a Java class with only a
  # no-arg constructor, then an exception is raised when that
  # Ruby class is instantiated.
  def self.new_instance(life_model)
    instance = LifeTableModel.new
    instance.init(life_model)
    instance
  end

  def init(life_model)
    @life_model = life_model
    @generations = [life_model]
    @current_generation_num = 0
    @current_num_change_handlers = []
  end

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

  def getColumnName(colnum)
    nil
  end

  def current_generation_num=(new_num)
    @current_generation_num = new_num
    @current_num_change_handlers.each { |handler| handler.call }
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

  def go_to_previous_generation
    previous_generation_num = current_generation_num - 1
    self.life_model = generations[previous_generation_num]
    self.current_generation_num = previous_generation_num
  end

  def add_current_num_change_handler(callable)
    @current_num_change_handlers << callable
  end
end