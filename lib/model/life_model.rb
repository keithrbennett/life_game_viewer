require_relative "life_calculator"

# Object that contains and serves (stores and retrieves)
# living/dead states in the matrix.
#
# All public methods here should be responded to in alternate
# model implementations.
#
# See Wikipedia for more information about Conway's Game of Life.
#
# Rules distilled:
#
# 1) Any live cell with fewer than two live neighbours dies, as if caused by under-population.
# 2) Any live cell with two or three live neighbours lives on to the next generation.
# 3) Any live cell with more than three live neighbours dies, as if by overcrowding.
# 4) Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

class LifeModel
  
  attr_accessor :data

  # Creates an instance with the specified number of rows and columns.
  # All values are initialized to false.
  def initialize(rows, columns)
    @data = create_data(rows, columns)
  end

  # Creates a LifeModel instance whose size and values are specified
  # in the passed string.  Rows must be delimited by "\n".  The '*'
  # character represents true, and any other value will evaluate to false.
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

  def next_generation_model
    LifeCalculator.new.next_generation(self)
  end

  def to_s
    super.to_s + ": #{row_count} rows, #{column_count} columns, #{number_living} alive."
  end

  def ==(other)
    other.is_a?(LifeModel)             &&
    other.row_count == row_count       &&
    other.column_count == column_count &&
    other.data == data
  end

  def number_living
    num = 0
    (0...row_count).each do |row|
      (0...column_count).each do |col|
        num += 1 if alive?(row, col)
      end
    end
    num
  end

  private

  def create_data(rows, columns)
    data = []
    rows.times { |n| data << Array.new(columns, false) }
    data
  end

end
