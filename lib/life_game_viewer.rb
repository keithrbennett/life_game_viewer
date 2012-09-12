#!/usr/bin/env ruby


module LifeGameViewer

  platform_ok = /java$/ === RUBY_PLATFORM
  version_ok  = ! (/^1.8/ === RUBY_VERSION)

  unless platform_ok
    raise "This program must be run in JRuby running in 1.9 mode.\n"
  end

  unless version_ok
    raise \
"""This program must be run in JRuby in 1.9 mode.
Make sure the environment variable JRUBY_OPTS is set to include '--1.9'.
"""
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
