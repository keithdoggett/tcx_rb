# frozen_string_literal: true

require 'tcx_rb/version'
require 'tcx_rb/parser'
require 'tcx_rb/trackpoint'
require 'tcx_rb/lap'
require 'tcx_rb/activity'
require 'tcx_rb/workout'

module TcxRb
  class Error < StandardError; end
  # Your code goes here...

  def self.workout_from_str(tcx_str)
    parser = TcxRb::Parser.new(tcx_str)
    workout = parser.parse_activities

    activities = workout.map do |activity|
      activity[:laps] = generate_laps(activity[:laps])
      TcxRb::Activity.new(activity)
    end
    TcxRb::Workout.new(activities)
  end

  def self.workout_from_file(path)
    str = File.read(path)
    workout_from_str(str)
  end

  class << self
    private

    def generate_laps(laps)
      laps.map do |lap|
        lap[:trackpoints] = generate_trackpoints(lap[:trackpoints])
        TcxRb::Lap.new(lap)
      end
    end

    def generate_trackpoints(trackpoints)
      trackpoints.map do |tp|
        TcxRb::Trackpoint.new(tp)
      end
    end
  end
end
