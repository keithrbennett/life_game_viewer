class ModelValidation

  def required_class_methods
    [
        :create_from_string
    ]
  end

  def required_instance_methods
    [
        :row_count,
        :column_count,
        :alive?,
        :set_living_state,
        :set_living_states,
        :next_generation_model,
        :number_living
    ]
  end

  def class_methods_missing(instance)
    required_class_methods - instance.class.methods
  end

  def instance_methods_missing(instance)
    required_instance_methods - instance.methods
  end

  def methods_missing(instance)
    names_with_self_prefix = class_methods_missing(instance).map { |m| "self.#{m}" }
    names_with_self_prefix + instance_methods_missing(instance)
  end

  def methods_missing_message(instance)
    missing_methods = methods_missing(instance)
    missing_methods.empty? \
        ? nil
        : "Model is missing the following required methods: #{missing_methods.join(", ")}."
  end
  private
end