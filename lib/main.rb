#!/usr/bin/env ruby

unless /java$/ === RUBY_PLATFORM
  puts "This program must be run in JRuby."
  exit -1
end

require_relative 'view/life_game_viewer'

LifeGameViewer.view_sample
