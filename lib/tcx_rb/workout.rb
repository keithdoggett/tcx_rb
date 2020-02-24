# frozen_string_literal: true

module TcxRb
  class Workout
    def initialize(activities = [])
      @activities = activities
    end
    attr_accessor :activities

    def +(other)
      Workout.new(@activities + other.activities)
    end

    def -(other)
      Workout.new(@activities - other.activities)
    end

    def max_heart_rate
      @activities.map(&:max_heart_rate).max
    end

    def min_heart_rate
      @activities.map(&:min_heart_rate).min
    end

    def avg_heart_rate
      total = total_tps.to_f
      @activities.sum { |act| (act.total_tps / total) * act.avg_heart_rate }
    end

    def max_altitude
      @activities.map(&:max_altitude).max
    end

    def min_altitude
      @activities.map(&:min_altitude).min
    end

    def avg_altitude
      total = total_tps.to_f
      @activities.sum { |act| (act.total_tps / total) * act.avg_altitude }
    end

    def max_pace
      @activities.map(&:max_pace).max
    end

    def min_pace
      @activities.map(&:min_pace).min
    end

    def avg_pace
      total_distance / total_time
    end

    def total_tps
      @activities.sum(&:total_tps)
    end

    def total_time
      @activities.sum(&:total_time)
    end

    def total_distance
      @activities.sum(&:total_distance)
    end
  end
end
