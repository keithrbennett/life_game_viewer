require_relative 'model/life_model'
require_relative 'view/life_table_model'
require_relative 'view/main_frame'


def start_string
  str = ''
  20.times { str << ('*-' * 10) << "\n" }
  str
end


life_model = LifeModel.create_from_string(start_string)
MainFrame.new(life_model).set_visible(true)

