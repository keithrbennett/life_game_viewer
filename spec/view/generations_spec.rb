require 'rspec'
require_relative '../spec_helper'

# Fix so that it's not necessary to specify relative path.
require_relative '../../lib/view/generations'
require_relative '../../lib/life_model'

describe Generations do

  it "should instantiate correctly, and accessors should work properly" do
    life_model = LifeModel.new(3, 3)
    generations = Generations.new(life_model)
    generations.current.should == life_model
    generations.current_num.should == 0
    generations.found_last_generation?.should be_false
    generations.current_is_last?.should be_false
  end

  it "should calculate last generation correctly" do
    Generations.new(LifeModel.create_from_string"**\n**")
    pending
  end

end

