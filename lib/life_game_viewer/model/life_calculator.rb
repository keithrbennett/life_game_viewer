# Performs calculations relating to determination of a cell's neighbors
# and the next generation.  Generally, 'next_generation' will be the
# only method that will need to be called, but the others are provided
# publicly, since the Game of Life is all about experimentation.
#
# See Wikipedia for more information about Conway's Game of Life.
#
# Rules distilled:
#
# 1) Any live cell with fewer than two live neighbours dies, as if caused by under-population.
# 2) Any live cell with two or three live neighbours lives on to the next generation.
# 3) Any live cell with more than three live neighbours dies, as if by overcrowding.
# 4) Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

class LifeCalculator

  # Returns a new model with the next generation's data.
  def next_generation(old_model)
    old_model.class.send(:create, old_model.row_count, old_model.column_count) do |row, col|
      should_live(old_model, row, col)
    end
  end

  # Returns an array of [row, col] tuples corresponding to the cells
  # neighboring the specified cell location.  "Neighbor" is defined
  # as a cell with up/down/left/right/diagonal adjacency to the specified cell.
  def neighbors(model, row, col)

    neighbors = []

    at_left_edge   = col == 0
    at_right_edge  = col == model.column_count - 1
    at_top_edge    = row == 0
    at_bottom_edge = row == model.row_count - 1

    col_to_left  = col - 1
    col_to_right = col + 1
    row_above    = row - 1
    row_below    = row + 1

    # In its own row, return the cell to the left and right as possible.
    unless at_left_edge;   neighbors << [row, col_to_left]   end
    unless at_right_edge;  neighbors << [row, col_to_right]  end

    # Process the row above
    unless at_top_edge
      neighbors << [row_above, col]
      neighbors << [row_above, col_to_left]  unless at_left_edge
      neighbors << [row_above, col_to_right] unless at_right_edge
    end

    # Process the row below
    unless at_bottom_edge
      neighbors << [row_below, col]
      neighbors << [row_below, col_to_left]  unless at_left_edge
      neighbors << [row_below, col_to_right] unless at_right_edge
    end

    neighbors

  end


  # Returns an array of [row, col] tuples corresponding to those
  # neighbor cells that are alive.
  def num_living_neighbors(model, row, col)
    neighbors(model, row, col).inject(0) do |num_living, neighbor|
      neighbor_row, neighbor_column = neighbor
      num_living += 1 if model.alive?(neighbor_row, neighbor_column)
      num_living
    end
  end


  # Returns whether or not (as true or false) the specified cell
  # should continue to live in the next generation.
  def should_live(model, row, col)
    model.alive?(row, col) \
        ? live_cell_should_continue_to_live(model, row, col) \
        : dead_cell_should_become_alive(model, row, col)
  end

  def live_cell_should_continue_to_live(model, row, col)
    (2..3).include?(num_living_neighbors(model, row, col))
  end

  def dead_cell_should_become_alive(model, row, col)
    num_living_neighbors(model, row, col) == 3
  end

end
