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
    self[current_num]
  end

  def current_num=(new_num)
    need_to_notify_listeners = current_num != new_num
    @current_num = new_num
    fire_current_number_changed if need_to_notify_listeners
  end

  def found_last_generation?
    !!@last_num
  end

  def at_last_generation?
    current_num == @last_num
  end

  def at_first_generation?
    current_num == 0
  end

  def ensure_next_in_cache
    at_end_of_array = (current_num == (size - 1))
    need_to_get_new_model = at_end_of_array && (! found_last_generation?)
    if need_to_get_new_model
      tentative_next = current.next_generation_model
      if tentative_next == current
        @last_num = current_num
      else
        self << tentative_next
      end

    end
  end

  def next
    raise "Next was called when at end of lineage." if at_last_generation?
    self.current_num = current_num + 1
    ensure_next_in_cache
    fire_current_number_changed
    current
  end

  def previous
    raise "Previous was called when at first generation." if at_first_generation?
    self.current_num = current_num - 1
    fire_current_number_changed
    current
  end

  def add_current_num_change_handler(callable)
    @current_num_change_handlers << callable
  end

  def fire_current_number_changed
    @current_num_change_handlers.each do |handler|
      handler.call(current_num)
    end
  end
end
