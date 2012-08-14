require 'rspec'
require_relative '../spec_helper'

# Fix so that it's not necessary to specify relative path.
require_relative '../../lib/view/generations'
require_relative '../../lib/life_model'

describe Generations do

  it "should instantiate correctly, and accessors should work properly" do
    life_model = LifeModel.new(3, 3)
    generation = Generations.new(life_model)
    generation.current.should == life_model
    generation.size.should == 1
    generation.current_num.should == 0
  end

  it "should calculate last generation correctly" do
    Generations.new(LifeModel.create_from_string"**\n**")
    pending
  end

end

