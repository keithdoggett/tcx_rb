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
  end
end
