require 'rspec'
require 'model/model_validation'
require 'model/life_model_sample_implementation'

describe ModelValidation do

  subject { ModelValidation.new }

  it "should return success on a model with all required methods" do
    model = LifeModelSampleImplementation.new(1,1)
    subject.methods_missing_message(model).should be_nil
  end

  it "should correctly detect the absence of the first required class method" do
    model = Object.new
    first_required_class_method = subject.required_class_methods.first
    regexp = Regexp.new(first_required_class_method.to_s)
    message = subject.methods_missing_message(model)
    message.should match(regexp)
  end

  it "should correctly detect the absence of the last required instance method" do
    model = Object.new
    last_required_instance_method = subject.required_class_methods.first
    regexp = Regexp.new(last_required_instance_method.to_s)
    message = subject.methods_missing_message(model)
    message.should match(regexp)
  end


end
