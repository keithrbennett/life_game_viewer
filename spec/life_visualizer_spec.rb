require_relative 'spec_helper'

require 'life_visualizer'

describe LifeVisualizer do
  
  subject { LifeVisualizer.new }
  let (:model) { LifeModel.new(5, 8) }
  
  it "should return a 5 line string" do
    subject.visualize_as_string(model).count("\n").should == 5
  end
  
  it "should return '*' for alive and '-' for dead" do
    model = LifeModel.new(1, 2)
    model.set_living_state(0, 1, true)
    tokens = subject.visualize_as_string(model).split(' ')
    tokens.should == ['-', '*']
  end
  
end
