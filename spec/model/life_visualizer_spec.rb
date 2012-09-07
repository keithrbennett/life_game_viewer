require_relative '../spec_helper'

require 'model/life_visualizer'

describe LifeVisualizer do
  
  subject { LifeVisualizer.new }
  let (:model) { LifeModelSampleImplementation.new(5, 8) }
  
  it "should return a 5 line string" do
    subject.to_display_string(model).count("\n").should == 5
  end
  
  it "should return '*' for alive and '-' for dead" do
    model = LifeModelSampleImplementation.new(1, 2)
    model.set_living_state(0, 1, true)
    subject.to_display_string(model).chomp.should == "-*"
  end
  
end
