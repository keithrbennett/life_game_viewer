# Manages the string display of a life model.
require_relative 'life_model'

java_import 'java.awt.Toolkit'
java_import 'java.awt.datatransfer.StringSelection'


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

  def copy_to_clipboard(model)
    clipboard = Toolkit.default_toolkit.system_clipboard
    string_selection = StringSelection.new(to_display_string(model))
    clipboard.setContents(string_selection, self)
  end


end
