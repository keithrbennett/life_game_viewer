require 'java'

java_import 'javax.swing.JFrame'
java_import 'javax.swing.JLabel'
java_import 'javax.swing.JTable'
java_import 'java.awt.BorderLayout'


class MainFrame < JFrame

  attr_accessor :life_model

  def initialize(life_model)
    super('The Game of Life')
    @life_model = life_model
    @life_table_model = LifeTableModel.new_instance(@life_model)
    set_default_close_operation(JFrame::EXIT_ON_CLOSE)
    add(JTable.new(@life_table_model), BorderLayout::CENTER)
    pack
  end

end