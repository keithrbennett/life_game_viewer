# Manages the string display of a life model.
require_relative 'life_model'

class LifeVisualizer

  # Outputs to stdout a string representation of a LifeModel.
  def visualize(model)
    puts visualize_as_string(model)
  end
  
  # Returns a string representation of a LifeModel.
  def visualize_as_string(model)
    output = ''
    
    (0...model.row_count).each do |x|
      (0...model.column_count).each do |y|
        output << alive_as_string(model.alive?(x, y)) << ' '
      end
      output << "\n"
    end
    
    output
  end
  
  private

  # Returns a string representing living/dead state.
  def alive_as_string(alive)
    alive ? '*' : '-'
  end
end
