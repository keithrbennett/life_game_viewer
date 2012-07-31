require 'rspec'
require_relative 'spec_helper'
require 'life_model'

describe LifeModel do

  subject { LifeModel.new(12, 20) }

  it "should be a LifeModel" do
    subject.should be_a LifeModel
  end
  
  it "should have 12 rows" do
    subject.row_count.should equal 12
  end
  
  it "should have 20 columns" do
    subject.column_count.should equal 20
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
    model = LifeModel.new(3, 3)
    cells_to_set_alive = [[0,0], [1,1], [2,2]]
    model.set_living_states(cells_to_set_alive, true)
    cells_to_set_alive.all? do |tuple|
      row, col = tuple
      model.alive?(row, col)
    end.should be_true
  end


  it "should create a model from a string" do
    s = "*.\n.*\n.."
    model = LifeModel.create_from_string(s);

    model.row_count.should == 3
    model.column_count.should == 2
    model.alive?(0, 0).should be_true
    model.alive?(0, 1).should be_false
    model.alive?(1, 0).should be_false
    model.alive?(1, 1).should be_true
  end


  it "should be considered == correctly" do
    model_string = "*****\n-----\n*-*-*"
    model1 = LifeModel.create_from_string(model_string)
    model2 = LifeModel.create_from_string(model_string)
    model1.should == model2
  end

  it "should be considered != when row count is different" do
    model1 = LifeModel.create_from_string("*****\n-----\n*-*-*")
    model2 = LifeModel.create_from_string("*****\n-----")
    model1.should_not == model2
  end

  it "should be considered != when column count is different" do
    model1 = LifeModel.create_from_string("*****\n-----\n*-*-*")
    model2 = LifeModel.create_from_string("****\n----\n*-*-")
    model1.should_not == model2
  end

  it "should be considered != when an alive flag is different" do
    model1 = LifeModel.create_from_string("*****\n-----\n*-*-*")
    model2 = LifeModel.create_from_string("*****\n--*--\n*-*-*")
    model1.should_not == model2
  end

end
