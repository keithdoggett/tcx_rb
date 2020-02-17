# frozen_string_literal: true

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
  end
end
