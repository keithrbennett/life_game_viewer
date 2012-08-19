class Generations < Array

  attr_reader :current_num, :last_num

  def initialize(life_model)
    self << life_model
    @current_num = 0
    @last_num = nil
    @current_num_change_handlers = []
    ensure_next_in_cache
  end

  def current
    self[@current_num]
  end

  def current_num=(new_num)
    need_to_notify_listeners = current_num != new_num
    @current_num = new_num
    if need_to_notify_listeners
      @current_num_change_handlers.each { |handler| handler.call(@current_generation_num) }
    end
  end

  def found_last_generation?
    !!@last_num
  end

  def at_last_generation?
    @current_num == @last_num
  end

  def at_first_generation?
    @current_num = 0
  end

  def ensure_next_in_cache
    puts "last_num = #{@last_num}"
    puts "current_num = #{@current_num}"
    puts "size = #{size}"
    at_end_of_array = @current_num == (size - 1)
    puts "at end of array = #{at_end_of_array}"
    need_to_get_new_model = at_end_of_array && (! found_last_generation?)
    puts "need to get new model = #{need_to_get_new_model}"
    if need_to_get_new_model
      tentative_next = current.next_generation_model
      puts "tentative next = #{tentative_next}"
      if tentative_next == current
        @last_num = current_num
        puts "last num = #{last_num}"
      else
        puts "Appending model to array."
        self << tentative_next
        puts "size = #{size}"
        puts "Cached data is: #{self[size-1]}"
      end

    end
  end

  def current_is_last?
    last_num == current_num
  end

  def next
    raise "Next was called when at end of lineage." if current_is_last?
    @current_num += 1
    puts "Size = #{size}"
    puts "\nCurrent num is #{@current_num}\n\n  "
    puts "self[#{current_num}] = #{self[current_num]}"
    puts "current = #{current}"
    raise "Before: Current is nil!" if current.nil?
    ensure_next_in_cache
    raise "After: Current is nil!" if current.nil?
    current
  end

  def add_current_num_change_handler(callable)
    @current_num_change_handlers << callable
  end
end
