# Object that contains and serves (stores and retrieves)
# living/dead states in the matrix.


class LifeModel

  # You may want to copy certain methods from SampleLifeModel that you don't
  # feel the need to implement yourself.  For example, the to_s and ==
  # methods may be helpful to you in your development and testing.
  # Also, set_living_states is a convenience method that merely calls
  # your set_living_state method.

  # Because this viewer is just a tool and should not drive your implementation,
  # there are no assumptions about your constructor -- you are free to do whatever
  # you want with it.  Instead, we require a couple of static factory methods
  # needed by the application.

  # Creates and returns a LifeModel instance whose size and values are specified
  # in the passed string.  Rows must be delimited by "\n".  The '*'
  # character represents true, and any other value will evaluate to false.
  def self.create_from_string(string)
  end

  # This method will create a model with the specified number of rows and
  # columns. If a block is passed it will be used to initialize the
  # alive/dead values; the block should take params row and column number.
  def self.create(row_count, column_count)
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

  def number_living
  end

  def to_s
  end

  def ==(other)
  end
end
