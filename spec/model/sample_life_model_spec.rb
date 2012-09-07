require 'rspec'

require_relative '../spec_helper'

require 'model/sample_life_model'

describe SampleLifeModel do

  subject { SampleLifeModel.new(12, 20) }

  it "should be a SampleLifeModel" do
    subject.should be_a SampleLifeModel
  end
  
  it "should have 12 rows" do
    subject.row_count.should == 12
  end
  
  it "should have 20 columns" do
    subject.column_count.should == 20
  end
  
  it "should have all rows default to false" do
    subject.data.flatten.any? { |obj| obj != false }.should be_false
  end

  it "should have all rows default to not alive" do
    any_alive = false
    (0...subject.row_count).each do |rownum|
      (0...subject.column_count).each do |colnum|
        if subject.alive?(rownum, colnum)
          any_alive = true
        end
      end
    end
    any_alive.should be_false      
  end
    
  it "should be able to set and get alive on a cell" do
    subject.set_living_state(0, 0, true)
    subject.alive?(0, 0).should be_true
  end

  it "should set living state correctly using set_living_states" do
    model = SampleLifeModel.new(3, 3)
    cells_to_set_alive = [[0,0], [1,1], [2,2]]
    model.set_living_states(cells_to_set_alive, true)
    cells_to_set_alive.all? do |tuple|
      row, col = tuple
      model.alive?(row, col)
    end.should be_true
  end


  it "should create a model from a string" do
    s = "*.\n.*\n.."
    model = SampleLifeModel.create_from_string(s);

    model.row_count.should == 3
    model.column_count.should == 2
    model.alive?(0, 0).should be_true
    model.alive?(0, 1).should be_false
    model.alive?(1, 0).should be_false
    model.alive?(1, 1).should be_true
  end


  it "should be considered == correctly" do
    model_string = "*****\n-----\n*-*-*"
    model1 = SampleLifeModel.create_from_string(model_string)
    model2 = SampleLifeModel.create_from_string(model_string)
    model1.should == model2
  end

  it "should be considered != when row count is different" do
    model1 = SampleLifeModel.create_from_string("*****\n-----\n*-*-*")
    model2 = SampleLifeModel.create_from_string("*****\n-----")
    model1.should_not == model2
  end

  it "should be considered != when column count is different" do
    model1 = SampleLifeModel.create_from_string("*****\n-----\n*-*-*")
    model2 = SampleLifeModel.create_from_string("****\n----\n*-*-")
    model1.should_not == model2
  end

  it "should be considered != when an alive flag is different" do
    model1 = SampleLifeModel.create_from_string("*****\n-----\n*-*-*")
    model2 = SampleLifeModel.create_from_string("*****\n--*--\n*-*-*")
    model1.should_not == model2
  end

  it "should be able to use a passed block to initialize all cells to true" do
    model = SampleLifeModel.create(3, 3) { |row, col| true }
    model.number_living.should == 9
  end

  it "should be able to use a passed block to initialize all cells to false" do
    model = SampleLifeModel.create(3, 3) { |row, col| false }
    model.number_living.should == 0
  end

  it "should be able to use a passed block to set only 1,2 to true" do
    model = SampleLifeModel.create(3, 3) { |row, col| row == 1 && col == 2 }
    (model.number_living.should == 1 && model.alive?(1, 2)).should be_true
  end

end
