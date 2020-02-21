# frozen_string_literal: true

require 'test_helper'
require 'time'

class LapTest < Minitest::Test
  def setup
    ref_time = Time.now
    @test_tps = [
      { time: ref_time, altitude: 0, distance: 0, heart_rate: 50 },
      { time: ref_time + 5, altitude: 10, distance: 15, heart_rate: 100 },
      { time: ref_time + 10, altitude: 5, distance: 20, heart_rate: 150 }
    ].map { |tp_data| TcxRb::Trackpoint.new(tp_data) }

    # on my watch, if I pause it, distance goes to 0.0 midway through
    # workout. These need to be ignored because you'd have a negative pace
    # for min or a ridiculously high pace for max once you turn it back on.
    # Also to caclulate the actual average pace we should use this instead
    # of information on lap because that counts time paused.
    @additional_data = [
      { time: ref_time + 15, altitude: 0, distance: 0, heart_rate: 50 },
      { time: ref_time + 20, altitude: 10, distance: 0, heart_rate: 100 },
      { time: ref_time + 25, altitude: 5, distance: 26, heart_rate: 150 }
    ].map { |tp_data| TcxRb::Trackpoint.new(tp_data) }
    @lap = TcxRb::Lap.new(trackpoints: @test_tps)
    @pace_lap = TcxRb::Lap.new(trackpoints: @test_tps + @additional_data,
                               distance: 26)
  end

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

  def test_max_heart_rate
    assert_equal(150.0, @lap.max_heart_rate)
  end

  def test_min_heart_rate
    assert_equal(50.0, @lap.min_heart_rate)
  end

  def test_avg_heart_rate
    assert_equal(100.0, @lap.avg_heart_rate)
  end

  def test_max_altitude
    assert_equal(10.0, @lap.max_altitude)
  end

  def test_min_altitude
    assert_equal(0.0, @lap.min_altitude)
  end

  def test_avg_altitude
    assert_equal(5.0, @lap.avg_altitude)
  end

  def test_max_pace
    # pace in m/s
    assert_equal(3.0, @pace_lap.max_pace)
  end

  def test_min_pace
    assert_equal(1.0, @pace_lap.min_pace)
  end

  def test_active_time
    assert_equal(15, @pace_lap.active_time)
  end

  def test_avg_pace
    assert_equal(26.0 / 15, @pace_lap.avg_pace)
  end
end
