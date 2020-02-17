# frozen_string_literal: true

require 'time'

module TcxRb
  class Trackpoint
    def initialize(args = {})
      @time = args[:time].to_s
      @latitude = args[:latitude].to_f
      @longitude = args[:longitude].to_f
      @altitude = args[:altitude].to_f
      @distance = args[:distance].to_f
      @heart_rate = args[:heart_rate].to_i
    end
    attr_accessor :time, :latitude, :longitude, :altitude, :distance, :heart_rate
    alias lat latitude
    alias lon longitude
  end
end
