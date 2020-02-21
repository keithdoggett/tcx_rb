# frozen_string_literal: true

module TcxRb
  class Activity
    def initialize(args = {})
      @sport = args[:sport]
      @id = args[:id]
      @creator = args[:creator]
      @laps = args[:laps]
    end
    attr_accessor :sport, :id, :creator, :laps

    def max_heart_rate
      @laps.map(&:max_heart_rate).max
    end

    def min_heart_rate
      @laps.map(&:min_heart_rate).min
    end

    def avg_heart_rate
      # weighted average of each laps avg_heart_rate based on
      # trackpoints size
      total = total_tps.to_f
      @laps.sum { |lap| (lap.trackpoints.size / total) * lap.avg_heart_rate }
    end

    def max_altitude
      @laps.map(&:max_altitude).max
    end

    def min_altitude
      @laps.map(&:min_altitude).min
    end

    def avg_altitude
      total = total_tps.to_f
      @laps.sum { |lap| (lap.trackpoints.size / total) * lap.avg_altitude }
    end

    def max_pace
      @laps.map(&:max_pace).max
    end

    def min_pace
      @laps.map(&:min_pace).min
    end

    def avg_pace
      total_distance / total_time
    end

    private

    def total_tps
      @laps.sum { |lap| lap.trackpoints.size }
    end

    def total_time
      @laps.sum(&:active_time)
    end

    def total_distance
      @laps.sum(&:distance)
    end
  end
end
