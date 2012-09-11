#!/usr/bin/env ruby


module LifeGameViewer

  unless /java$/ === RUBY_PLATFORM
    puts "This program must be run in JRuby."
    exit -1
  end

  require 'java'

  %w(
      life_game_viewer/version.rb
      life_game_viewer/model/life_calculator
      life_game_viewer/model/life_visualizer
      life_game_viewer/model/model_validation
      life_game_viewer/model/sample_life_model
      life_game_viewer/view/actions
      life_game_viewer/view/clipboard_helper
      life_game_viewer/view/generations
      life_game_viewer/view/main
      life_game_viewer/view/life_game_viewer_frame
      life_game_viewer/view/life_table_model
  ).each { |file| require_relative(file) }

end
