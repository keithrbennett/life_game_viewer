#!/usr/bin/env ruby

#require_relative 'model/sample_life_model'
#require_relative 'view/life_table_model'
require_relative 'view/life_game_viewer_frame'

class LifeGameViewer

  def self.view_sample
    LifeGameViewerFrame.view_sample
  end

  def self.view(model)
    LifeGameViewerFrame.new(model).visible = true
  end
end
