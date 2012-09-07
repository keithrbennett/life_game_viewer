#!/usr/bin/env ruby

require_relative 'model/sample_life_model'
require_relative 'view/life_table_model'
require_relative 'view/main_frame'

class LifeGameViewer

  def sample_start_string
    str = ''
    12.times { str << ('*-' * 6) << "\n" }
    str
  end

  def view(first_generation_model = SampleLifeModel.create_from_string(sample_start_string))
    MainFrame.new(first_generation_model).set_visible(true)
  end
end