# frozen_string_literal: true

require 'test_helper'

class WorkoutTest < Minitest::Test
  def test_initialize
    activities = [TcxRb::Activity.new, TcxRb::Activity.new]
    workout = TcxRb::Workout.new(activities)
    assert_equal(2, workout.activities.size)
  end
end
