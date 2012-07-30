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
    puts subject
    (0...subject.row_count).each do |rownum|
      puts "rownum = #{rownum}"
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
  
    

end
