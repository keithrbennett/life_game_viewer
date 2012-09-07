require 'rspec'
require_relative '../spec_helper'

require 'view/generations'
require 'model/sample_life_model'

describe Generations do

  it "should handle an empty 3x3 matrix correctly" do
    life_model = SampleLifeModel.create(3, 3)
    generations = Generations.new(life_model)
    generations.current.should == life_model
    generations.current_num.should == 0
  end

  # It's difficult to come up with tests for this class that don't really
  # test the underlying model's next generation calculation.
end

