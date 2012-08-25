# Manages the string display of a life model.
require_relative 'life_model'

class LifeVisualizer

  # Returns a string representation of a LifeModel.
  def to_display_string(model)
    output = ''
    
    (0...model.row_count).each do |x|
      (0...model.column_count).each do |y|
        alive_as_string = model.alive?(x, y) ? '*' : '-'
        output << alive_as_string
      end
      output << "\n"
    end
    
    output
  end
end
