class LifeCalculator

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
    unless at_left_edge
      neighbors << [row, col_to_left]
    end
    unless at_right_edge
      neighbors << [row, col_to_right]
    end

    # Process the row above
    unless at_top_edge
      unless at_left_edge
        neighbors << [row_above, col_to_left]
      end
      neighbors << [row_above, col]
      unless at_right_edge
        neighbors << [row_above, col_to_right]
      end
    end

    # Process the row below
    unless at_bottom_edge
      unless at_left_edge
        neighbors << [row_below, col_to_left]
      end
      neighbors << [row_below, col]
      unless at_right_edge
        neighbors << [row_below, col_to_right]
      end
    end

    neighbors

  end


  def num_living_neighbors(model, row, col)
    neighbors(model, row, col).inject(0) do |num_living, neighbor|
      neighbor_row, neighbor_column = neighbor
      num_living += 1 if model.alive?(neighbor_row, neighbor_column)
      num_living
    end
  end


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

    # Returns a new model with the next generation's data.
  def next_generation(old_model)
    new_model = LifeModel.new(old_model.row_count, old_model.column_count)
    (0...old_model.row_count).each do |row|
      (0...old_model.column_count).each do |col|
        new_model.set_living_state(row, col, should_live(old_model, row, col))
      end
    end
    new_model
  end

end
