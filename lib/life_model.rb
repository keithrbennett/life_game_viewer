class LifeModel
  
  attr_accessor :data
  
  def initialize(rows, columns)
    @data = create_data(rows, columns)
  end
  
  
  def row_count
    @data.size
  end
  
  def column_count
    @data[0].size
  end
  
  def alive?(x, y)
    @data[x][y]
  end
  
  def set_living_state(x, y, alive)
    @data[x][y] = alive
  end
  
  private
  
  def create_data(rows, columns)
    data = []
    rows.times { |n| data << Array.new(columns, false) }
    data
  end
  
  def to_s
    "LifeModel, #{row_count} rows, #{column_count} columns"
  end
  
end
