require 'rspec'
require 'model/model_validation'
require 'model/sample_life_model'

describe ModelValidation do

  subject { ModelValidation.new }

  it "should return success on a model with all required methods" do
    model = SampleLifeModel.new(1,1)
    subject.methods_missing_message(model).should be_nil
  end

  it "should correctly detect the absence of all instance methods" do
    model = Object.new
    methods_missing = subject.instance_methods_missing(model)
    all_are_detected = subject.required_instance_methods.all? do |method|
      methods_missing.include?(method)
    end
    all_are_detected.should be_true
  end

  it "should correctly detect the absence of all class methods" do
    model = Object.new
    methods_missing = subject.class_methods_missing(model)
    all_are_detected = subject.required_class_methods.all? do |method|
      methods_missing.include?(method)
    end
    all_are_detected.should be_true
  end

  it "should correctly detect the absence of all instance methods in message" do
    model = Object.new
    message = subject.methods_missing_message(model)
    all_are_detected = subject.required_instance_methods.all? do |method|
      message.include?(method.to_s)
    end
    all_are_detected.should be_true
  end

  it "should correctly detect the absence of all class methods in message" do
    model = Object.new
    message = subject.methods_missing_message(model)
    all_are_detected = subject.required_class_methods.all? do |method|
      message.include?('self.' + method.to_s)
    end
    all_are_detected.should be_true
  end

end

