# Object that contains and serves (stores and retrieves)
# living/dead states in the matrix.
#
# All public methods here should be responded to in alternate
# model implementations.

class LifeModel

  # Creates an instance with the specified number of rows and columns.
  # All values are initialized to false.
  def initialize(rows, columns)
  end

  # Creates and returns a LifeModel instance whose size and values are specified
  # in the passed string.  Rows must be delimited by "\n".  The '*'
  # character represents true, and any other value will evaluate to false.
  def self.create_from_string(string)
  end

  def row_count
  end

  def column_count
  end

  def alive?(row, col)
  end

  def set_living_state(row, col, alive)
  end

  def set_living_states(array_of_row_col_tuples, alive)
  end

  def next_generation_model
  end

  def to_s
    super.to_s + ": #{row_count} rows, #{column_count} columns, #{number_living} alive."
  end

  def ==(other)
  end

  def number_living
  end
end
