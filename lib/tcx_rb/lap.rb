# frozen_string_literal: true

require 'time'

module TcxRb
  class Lap
    def initialize(args = {})
      @start_time = args[:start_time].to_s
      @total_time = args[:total_time].to_f
      @distance = args[:distance].to_f
      @calories = args[:calories].to_i
      @intensity = args[:intensity]
      @trigger_method = args[:trigger_method]
      @trackpoints = args[:trackpoints]
    end
    attr_accessor :start_time, :total_time, :distance, :calories, :intensity, :trigger_method, :trackpoints

    def max_heart_rate
      @trackpoints.map(&:heart_rate).max
    end

    def min_heart_rate
      @trackpoints.map(&:heart_rate).min
    end

    def avg_heart_rate
      tot = @trackpoints.inject(0.0) { |sum, el| sum + el.heart_rate }
      tot / @trackpoints.size
    end

    def max_altitude
      @trackpoints.map(&:altitude).max
    end

    def min_altitude
      @trackpoints.map(&:altitude).min
    end

    def avg_altitude
      tot = @trackpoints.inject(0.0) { |sum, el| sum + el.altitude }
      tot / @trackpoints.size
    end

    def max_pace
      max = 0.0
      @trackpoints.each_with_index do |tp, i|
        # skip first cause we need to refrence previous
        # and if the current trackpoint is 0.0 in distance,
        # we will skip it because that means we're stopped
        next if i.zero? || tp.distance.zero?

        prev_tp = @trackpoints[i - 1]

        # also skip to the next one if i isn't 1 and the previous is 0
        # because we could get a ridiculously high pace.
        next if i != 1 && prev_tp.distance.zero?

        # now we can perform the calculation
        d_dist = tp.distance - prev_tp.distance
        d_t = Time.parse(tp.time) - Time.parse(prev_tp.time)
        pace = d_dist / d_t
        max = pace if pace > max
      end
      max
    end

    def min_pace
      min = Float::INFINITY
      @trackpoints.each_with_index do |tp, i|
        next if i.zero? || tp.distance.zero?

        prev_tp = @trackpoints[i - 1]
        next if i != 1 && prev_tp.distance.zero?

        d_dist = tp.distance - prev_tp.distance
        d_t = Time.parse(tp.time) - Time.parse(prev_tp.time)
        pace = d_dist / d_t
        min = pace if pace < min
      end
      min
    end

    def avg_pace
      # total distance of the workout is stored in @distance
      # in lap. We need to aggregate "active_time" from the trackpoints
      # to figure out how much time was actually spent moving, then take
      # the average that way. In this case, we will account for trackpoints
      # where the prev_tp is 0 and this one is active
      active_time = 0.0
      @trackpoints.each_with_index do |tp, i|
        next if i.zero? || tp.distance.zero?

        prev_tp = @trackpoints[i - 1]
        d_t = Time.parse(tp.time) - Time.parse(prev_tp.time)
        active_time += d_t
      end
      distance / active_time
    end
  end
end
