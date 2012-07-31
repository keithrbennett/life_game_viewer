class LifeModel
  
  attr_accessor :data
  
  def initialize(rows, columns)
    @data = create_data(rows, columns)
  end

  def self.create_from_string(string)
    row_count = string.chomp.count("\n") + 1
    lines = string.split("\n")
    col_count = lines.first.size
    model = LifeModel.new(row_count, col_count)
    (0...row_count).each do |row|
      line = lines[row]
      (0...(line.size)).each do |col|
        ch = line[col]
        alive = (ch == '*')
        model.set_living_state(row, col, alive)
      end
    end
    model
  end
  
  def row_count
    @data.size
  end
  
  def column_count
    @data[0].size
  end
  
  def alive?(row, col)
    @data[row][col]
  end
  
  def set_living_state(row, col, alive)
    @data[row][col] = alive
  end

  def set_living_states(array_of_row_col_tuples, alive)
    array_of_row_col_tuples.each do |row_col_tuple|
      row, col = row_col_tuple
      set_living_state(row, col, alive)
    end
  end

  private
  
  def create_data(rows, columns)
    data = []
    rows.times { |n| data << Array.new(columns, false) }
    data
  end
  
  def to_s
    super.to_s + ": #{row_count} rows, #{column_count} columns"
  end

  def ==(other)
    other.is_a?(LifeModel)             &&
    other.row_count == row_count       &&
    other.column_count == column_count &&
    other.data == data
  end
  
end
