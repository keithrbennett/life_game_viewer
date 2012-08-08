require_relative 'life_model'
require_relative 'life_calculator'
require_relative 'view/life_table_model'
require_relative 'view/main_frame'


class Main

  life_model = LifeModel.create_from_string("**********\n----------\n**********")
  MainFrame.new(life_model).set_visible(true)

end