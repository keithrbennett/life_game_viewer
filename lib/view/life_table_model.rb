require 'java'
java_import javax.swing.table.AbstractTableModel
java_import javax.swing.JOptionPane

require_relative 'generations'


class LifeTableModel < AbstractTableModel

  attr_accessor :life_model
  attr_reader :generations  # array of LifeModel's


  # This is necessary because of a JRuby bug -- if a Ruby class
  # with a 1-arg constructor subclasses a Java class with only a
  # no-arg constructor, then an exception is raised when that
  # Ruby class is instantiated.
  # See http://jira.codehaus.org/browse/JRUBY-2457 and
  # https://gist.github.com/3390231.
  def self.new_instance(life_model)
    instance = LifeTableModel.new
    instance.init(life_model)
    instance
  end

  def init(life_model)
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
    fire_table_data_changed
  end

  def fire_current_number_changed
    @current_num_change_handlers.each do |handler|
      handler.call(generations.current_num)
    end
  end
end


