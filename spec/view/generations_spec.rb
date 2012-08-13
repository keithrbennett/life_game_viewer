require 'rspec'
require_relative '../spec_helper'

# Fix so that it's not necessary to specify relative path.
require_relative '../../lib/view/generations'
require_relative '../../lib/life_model'

describe Generations do

  it "should instantiate" do
    Generations.new(LifeModel.new(3, 3))
  end

end
