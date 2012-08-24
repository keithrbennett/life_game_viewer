#!/usr/bin/env ruby

puts "Doing requires"

require_relative 'model/life_model'
require_relative 'view/life_table_model'
require_relative 'view/main_frame'

puts "Finished requires"

class LifeGameViewer

  def start_string
    str = ''
    20.times { str << ('*-' * 10) << "\n" }
    str
  end

  def view
    life_model = LifeModel.create_from_string(start_string)
    MainFrame.new(life_model).set_visible(true)
  end

  def self.hi
    puts "Hello world!  Enjoy LifeGameViewer!"
  end
end