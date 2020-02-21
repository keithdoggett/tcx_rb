# frozen_string_literal: true

require 'test_helper'

class ActivityTest < Minitest::Test
  def setup
    ref_time = Time.now
    @test_tps1 = [
      { time: ref_time, altitude: 0, distance: 0, heart_rate: 50 },
      { time: ref_time + 5, altitude: 10, distance: 15, heart_rate: 100 }
    ].map { |tp_data| TcxRb::Trackpoint.new(tp_data) }
    @test_tps2 = [
      { time: ref_time + 10, altitude: 10, distance: 0, heart_rate: 100 },
      { time: ref_time + 15, altitude: 20, distance: 10, heart_rate: 150 },
      { time: ref_time + 20, altitude: 30, distance: 15, heart_rate: 200 }
    ].map { |tp_data| TcxRb::Trackpoint.new(tp_data) }

    @lap1 = TcxRb::Lap.new(trackpoints: @test_tps1, distance: 15)
    @lap2 = TcxRb::Lap.new(trackpoints: @test_tps2, distance: 15)

    @activity = TcxRb::Activity.new(laps: [@lap1, @lap2])
  end

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

  def test_max_heart_rate
    assert_equal(200.0, @activity.max_heart_rate)
  end

  def test_min_heart_rate
    assert_equal(50.0, @activity.min_heart_rate)
  end

  def test_avg_heart_rate
    assert_equal(120.0, @activity.avg_heart_rate)
  end

  def test_max_altitude
    assert_equal(30.0, @activity.max_altitude)
  end

  def test_min_altitude
    assert_equal(0.0, @activity.min_altitude)
  end

  def test_avg_altitude
    assert_equal(14.0, @activity.avg_altitude)
  end

  def test_max_pace
    assert_equal(3.0, @activity.max_pace)
  end

  def test_min_pace
    assert_equal(1.0, @activity.min_pace)
  end

  def test_avg_pace
    assert_equal(2.0, @activity.avg_pace)
  end
end
