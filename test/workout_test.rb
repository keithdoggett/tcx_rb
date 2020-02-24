# frozen_string_literal: true

require 'test_helper'

class WorkoutTest < Minitest::Test
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

    @lap1 = TcxRb::Lap.new(trackpoints: @test_tps1, distance: 15, calories: 100)
    @lap2 = TcxRb::Lap.new(trackpoints: @test_tps2, distance: 15, calories: 100)

    @activity1 = TcxRb::Activity.new(laps: [@lap1])
    @activity2 = TcxRb::Activity.new(laps: [@lap2])
    @workout = TcxRb::Workout.new([@activity1, @activity2])
  end

  def test_initialize
    activities = [TcxRb::Activity.new, TcxRb::Activity.new]
    workout = TcxRb::Workout.new(activities)
    assert_equal(2, workout.activities.size)
  end

  def test_max_heart_rate
    assert_equal(200.0, @workout.max_heart_rate)
  end

  def test_min_heart_rate
    assert_equal(50.0, @workout.min_heart_rate)
  end

  def test_avg_heart_rate
    assert_equal(120.0, @workout.avg_heart_rate)
  end

  def test_max_altitude
    assert_equal(30.0, @workout.max_altitude)
  end

  def test_min_altitude
    assert_equal(0.0, @workout.min_altitude)
  end

  def test_avg_altitude
    assert_equal(14.0, @workout.avg_altitude)
  end

  def test_max_pace
    assert_equal(3.0, @workout.max_pace)
  end

  def test_min_pace
    assert_equal(1.0, @workout.min_pace)
  end

  def test_avg_pace
    assert_equal(2.0, @workout.avg_pace)
  end

  def test_add_overload
    workout1 = @workout
    workout2 = @workout
    new_workout = workout1 + workout2

    assert_equal(4, new_workout.activities.size)
  end

  def test_minus_overload
    workout1 = @workout
    workout2 = @workout

    new_workout = workout1 - workout2
    assert_equal(0, new_workout.activities.size)
  end

  def test_calories
    assert_equal(200, @workout.calories)
  end
end
