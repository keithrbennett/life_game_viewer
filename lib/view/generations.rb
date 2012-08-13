class Generations < Array

  attr_reader :life_model, :current_num, :last_num

  def initialize(life_model)
    @life_model = life_model
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
    if need_to_notify_listeners
      @current_num_change_handlers.each { |handler| handler.call(@current_generation_num) }
    end
  end

  def found_last_generation?
    !!@last_num
  end

  def ensure_next_in_cache
    if current_num == (size - 1) && (!found_last_generation?)
      tentative_next = current.next_generation_model
      if tentative_next == current
        @last_num = current_num
      else
        self << tentative_next
      end
    end
  end

  def current_is_last?
    last_num == current_num
  end

  def next
    raise "Next was called when at end of lineage." if current_is_last?
    @current_num += 1
    ensure_next_in_cache
    current
  end

  def add_current_num_change_handler(callable)
    @current_num_change_handlers << callable
  end

end
