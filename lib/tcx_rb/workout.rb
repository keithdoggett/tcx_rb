# frozen_string_literal: true

module TcxRb
  class Workout
    def initialize(activities = [])
      @activities = activities
    end
    attr_accessor :activities
  end
end
