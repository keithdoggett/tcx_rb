# frozen_string_literal: true

require 'test_helper'

class TcxRbTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::TcxRb::VERSION
  end

  def test_workout_from_str
    tcx_str = File.read('./test/data/test_data.tcx')
    workout = TcxRb.workout_from_str(tcx_str)
    assert_equal(2, workout.activities.size)
    assert_equal(2, workout.activities[0].laps.size)
    assert_equal(2, workout.activities[0].laps[0].trackpoints.size)
  end

  def test_workout_from_file
    path = './test/data/test_data.tcx'
    workout = TcxRb.workout_from_file(path)
    assert_equal(2, workout.activities.size)
    assert_equal(2, workout.activities[0].laps.size)
    assert_equal(2, workout.activities[0].laps[0].trackpoints.size)
  end
end
