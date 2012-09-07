#!/usr/bin/env ruby

unless /java$/ === RUBY_PLATFORM
  puts "This program must be run in JRuby."
  exit -1
end

require_relative 'life_game_viewer'

LifeGameViewer.new.view