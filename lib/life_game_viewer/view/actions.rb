# Contains Action classes used by the application.

require_relative 'clipboard_helper'


# Java Imports:
java_import %w(
    javax.swing.AbstractAction
)


# Generation Move Actions.  Class hierarchy is:
#
# MoveAction
# -- ShowPastGenerationAction
# -- -- ShowFirstGenerationAction
# -- -- ShowPreviousGenerationAction
# -- ShowFutureGenerationAction
# -- -- ShowNextGenerationAction
# -- -- ShowLastGenerationAction


class MoveAction < AbstractAction

  def initialize(table_model)
    super(caption)  # caption implemented by subclasses
    @table_model = table_model

    # should_be_enabled? below needs to be implemented by subclasses
    enabled_updater = lambda do |current_generation_num|
      self.enabled = should_be_enabled?
    end

    @table_model.add_current_num_change_handler(enabled_updater)

    self.enabled = enabled_updater.call(nil)
  end

  def actionPerformed(event)
    move  # implemented by subclasses
    @table_model.fire_table_data_changed
  end
end




class ShowPastGenerationAction < MoveAction

  def initialize(table_model)
    super(table_model)  # caption implemented by subclasses
  end

  def should_be_enabled?
    ! @table_model.at_first_generation?
  end
end




class ShowFirstGenerationAction < ShowPastGenerationAction

  def initialize(table_model)
    super(table_model)
  end

  def move
    @table_model.go_to_first_generation
  end

  def caption
    "First (1)"
  end
end




class ShowPreviousGenerationAction < ShowPastGenerationAction

  def initialize(table_model)
    super(table_model)
  end

  def move
    @table_model.go_to_previous_generation
  end

  def caption
    "Previous (4)"
  end
end




class ShowFutureGenerationAction < MoveAction

  def initialize(table_model)
    super(table_model)  # caption implemented by subclasses
  end

  def should_be_enabled?
    ! @table_model.at_last_generation?
  end
end




class ShowNextGenerationAction < ShowFutureGenerationAction

  def initialize(table_model)
    super(table_model)
  end

  def move
    @table_model.go_to_next_generation
  end

  def caption
    "Next (7)"
  end
end




class ShowLastGenerationAction < ShowFutureGenerationAction

  def initialize(table_model)
    super(table_model)
  end

  def move
    @table_model.go_to_last_generation
  end

  def caption
    "Last (0)"
  end
end




class ExitAction < AbstractAction

  # table_model param not used but needed for instantiation by create_button
  def initialize(table_model)
    super("Exit (Q)")
    put_value(SHORT_DESCRIPTION, 'Press capital-Q to exit.')
  end

  def actionPerformed(event)
    java.lang.System.exit(0)
  end
end




class CopyToClipboardAction < AbstractAction

  def initialize(table_model)
    super("Copy (C)")
    put_value(SHORT_DESCRIPTION, "Press #{ClipboardHelper.key_prefix}-C to copy board contents to clipboard.")
    @table_model = table_model
  end

  def actionPerformed(event)
    text = LifeVisualizer.new.to_display_string(@table_model.life_model)
    ClipboardHelper.clipboard_text = text
  end
end




class NewGameFromClipboardAction < AbstractAction

  def initialize(table_model)
    super("Paste (V)")
    put_value(SHORT_DESCRIPTION, "Press #{ClipboardHelper.key_prefix}-V to create a new game from the clipboard contents.")
    @table_model = table_model
  end

  def actionPerformed(event)
    new_model = @table_model.life_model.class.create_from_string(ClipboardHelper.clipboard_text)
    @table_model.reset_model(new_model)
  end
end
