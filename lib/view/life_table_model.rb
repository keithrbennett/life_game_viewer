require 'java'
java_import javax.swing.table.AbstractTableModel
java_import javax.swing.JOptionPane

require 'generations'


class LifeTableModel < AbstractTableModel

  attr_accessor :life_model
  attr_reader :generations  # array of LifeModel's
  attr_reader :current_generation_num
  attr_reader :last_generation_num


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
    @last_generation_num = nil
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

  def go_to_next_generation
    ensure_next_generation_loaded
    next_generation_num = current_generation_num + 1
    next_generation = generations[next_generation_num]

    # Last generation is defined as the generation after which
    # there are no changes.
    if next_generation == life_model
      @last_generation_num = current_generation_num
      JOptionPane.show_message_dialog(nil, "Generation ##{current_generation_num} is the last generation.")
    else
      self.life_model = next_generation
      self.current_generation_num = next_generation_num
    end
  end

  def go_to_previous_generation
    previous_generation_num = current_generation_num - 1
    self.life_model = generations[previous_generation_num]
    self.current_generation_num = previous_generation_num
  end

  def add_current_num_change_handler(callable)
    @generations.add_current_num_change_handler(callable)
  end
end


