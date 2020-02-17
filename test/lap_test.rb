# frozen_string_literal: true

require 'test_helper'

class LapTest < Minitest::Test
  def test_initialize
    lap_data = { start_time: '2020-02-11T19:40:22.000-05:00',
                 total_time: '1915.0', distance: '5782.0',
                 calories: '456', intensity: 'Active',
                 trigger_method: 'Manual', trackpoints: [TcxRb::Trackpoint.new] }
    lap = TcxRb::Lap.new(lap_data)
    assert_equal(lap_data[:start_time], lap.start_time)
    assert_equal(lap_data[:total_time].to_f, lap.total_time)
    assert_equal(lap_data[:distance].to_f, lap.distance)
    assert_equal(lap_data[:calories].to_i, lap.calories)
    assert_equal(lap_data[:intensity], lap.intensity)
    assert_equal(lap_data[:trigger_method], lap.trigger_method)
    assert_equal(lap_data[:trackpoints], lap.trackpoints)
  end
end
