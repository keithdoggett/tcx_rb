# frozen_string_literal: true

require 'test_helper'

class ActivityTest < Minitest::Test
  def test_initialize
    activity_data = {
      sport: 'Running', id: '2020-02-11T19:40:22.000-05:00',
      creator: 'Fitbit Ionic', laps: [TcxRb::Lap.new]
    }
    activity = TcxRb::Activity.new(activity_data)
    assert_equal(activity_data[:sport], activity.sport)
    assert_equal(activity_data[:id], activity.id)
    assert_equal(activity_data[:creator], activity.creator)
    assert_equal(activity_data[:laps], activity.laps)
  end
end
