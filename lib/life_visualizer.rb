require_relative 'life_model'

class LifeVisualizer
  
  def visualize(model)
    puts visualize_as_string(model)
  end
  
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
  
  def alive_as_string(alive)
    alive ? '*' : '-'
  end
end
