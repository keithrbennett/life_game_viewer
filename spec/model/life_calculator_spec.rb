require_relative '../spec_helper'

require 'model/life_calculator'
require 'model/life_visualizer'
require 'model/sample_life_model'

describe LifeCalculator do

  subject { LifeCalculator.new }

  # ============================================================
  # Neighbors
  # ============================================================

  it "should return cells on both sides for a non-edge cell of a 1x5 board" do
    model = SampleLifeModel.create(1, 5)
    subject.neighbors(model, 0, 3).sort.should == [[0,2], [0,4]]
  end

  it "should return 0,1 for 0,0 of a 1x5 board" do
    model = SampleLifeModel.create(1, 5)
    subject.neighbors(model, 0, 0).sort.should == [[0,1]]
  end

  it "should return 0,3 for 0,4 of a 1x5 board" do
    model = SampleLifeModel.create(1, 5)
    subject.neighbors(model, 0, 4).sort.should == [[0,3]]
  end

  it "should return 3 cells in the row above" do
    model = SampleLifeModel.create(2, 5)
    subject.neighbors(model, 1, 2).sort.should == \
        [[0,1], [0,2], [0,3], [1,1], [1,3]]
  end

  it "should return 3 cells in the row below" do
    model = SampleLifeModel.create(2, 5)
    subject.neighbors(model, 0, 2).sort.should == \
        [[0,1], [0,3], [1,1], [1,2], [1,3]]
  end

  it "should return 3 cells for lower left corner" do
    model = SampleLifeModel.create(2, 5)
      subject.neighbors(model, 1, 0).sort.should == \
        [ [0,0], [0,1], [1,1] ]
  end

  it "should return 3 cells for upper right corner" do
    model = SampleLifeModel.create(2, 5)
    subject.neighbors(model, 0, 4).sort.should == \
        [ [0,3], [1,3], [1,4] ]
  end

  it "should return 8 cells for a surrounded cell" do
    model = SampleLifeModel.create(3, 3)
    subject.neighbors(model, 1, 1).sort.should == \
        [[0,0], [0,1], [0,2], [1,0], [1,2], [2,0], [2,1], [2,2]]
  end

  # ============================================================
  # Dead Cell Calculations
  # ============================================================

  it "should calculate dead cell false correctly" do
    model = SampleLifeModel.create_from_string("--*\n**-")
    subject.dead_cell_should_become_alive(model, 0, 0).should be_false
    subject.should_live(model, 0, 0).should be_false
  end

  it "should calculate dead cell true correctly" do
    model = SampleLifeModel.create_from_string("--*\n**-")
    subject.dead_cell_should_become_alive(model, 0, 1).should be_true
    subject.should_live(model, 0, 1).should be_true
  end


  # ============================================================
  # Live Cell Calculations
  # ============================================================

  it "should calculate live cell false correctly" do
    model = SampleLifeModel.create_from_string("--*\n**-")
    subject.live_cell_should_continue_to_live(model, 1, 0).should be_false
    subject.should_live(model, 1, 0).should be_false
  end

  it "should calculate live cell true correctly" do
    model = SampleLifeModel.create_from_string("--*\n**-")
    subject.live_cell_should_continue_to_live(model, 1, 1).should be_true
    subject.should_live(model, 1, 1).should be_true
  end


  # ============================================================
  # Next Generation Model
  # ============================================================
  it "should return a next generation model different from the old" do
    model = SampleLifeModel.create_from_string("--*\n**-")
    next_gen_model = subject.next_generation(model)
    next_gen_model.should_not == model
  end


  it "should return a correct next generation model" do
    model = SampleLifeModel.create_from_string("--*\n**-")
    next_gen_model = subject.next_generation(model)
    expected_next_gen_model = SampleLifeModel.create_from_string("-*-\n-*-")
    next_gen_model.should == expected_next_gen_model
  end

end