require 'rspec'
require_relative '../spec_helper'

# Fix so that it's not necessary to specify relative path.
require 'view/generations'
require 'model/life_model'

describe Generations do

  it "should handle an empty 3x3 matrix correctly" do
    life_model = LifeModel.new(3, 3)
    generations = Generations.new(life_model)
    generations.current.should == life_model
    generations.current_num.should == 0
    generations.at_last_generation?.should be_true
  end

  it "should calculate last generation correctly" do
    Generations.new(LifeModel.create_from_string"**\n**")
    pending
  end

end

