require 'rspec'
require_relative '../spec_helper'

# Fix so that it's not necessary to specify relative path.
require 'view/generations'
require 'model/sample_life_model'

describe Generations do

  it "should handle an empty 3x3 matrix correctly" do
    life_model = SampleLifeModel.new(3, 3)
    generations = Generations.new(life_model)
    generations.current.should == life_model
    generations.current_num.should == 0
  end

end

