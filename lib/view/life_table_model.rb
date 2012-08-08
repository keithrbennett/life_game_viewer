require 'java'
java_import javax.swing.table.AbstractTableModel


class LifeTableModel < AbstractTableModel

  attr_accessor :life_model

  def self.new_instance(life_model)
    instance = LifeTableModel.new
    instance.life_model = life_model
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


end