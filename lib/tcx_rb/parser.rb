# frozen_string_literal: true

require 'nokogiri'

module TcxRb
  class Parser
    def initialize(tcx_str)
      @doc = Nokogiri::XML(tcx_str)
    end
    attr_reader :doc

    def parse_trackpoints(doc = @doc)
      # parse trackpoints from document and return hashes in the form of
      # {time, latitude, longitude, altitude, distance, heart_rate}
      doc.css('Trackpoint').map do |tp|
        tp_hash = {}
        tp_hash[:time] = tp.css('Time').text
        tp_hash[:latitude] = tp.css('Position/LatitudeDegrees').text
        tp_hash[:longitude] = tp.css('Position/LongitudeDegrees').text
        tp_hash[:altitude] = tp.css('AltitudeMeters').text
        tp_hash[:distance] = tp.css('DistanceMeters').text
        tp_hash[:heart_rate] = tp.css('HeartRateBpm/Value').text
        tp_hash
      end
    end

    def parse_laps(doc = @doc)
      # parse laps from document and returns hashes in the form of
      # {start_time, total_time, distance, calories, intensity, trigger_method,
      # trackpoints}
      doc.css('Lap').map do |lap|
        lap_hash = {}
        lap_hash[:start_time] = lap['StartTime']
        lap_hash[:total_time] = lap.css('TotalTimeSeconds').text
        lap_hash[:distance] = lap.css('DistanceMeters').first.text
        lap_hash[:calories] = lap.css('Calories').text
        lap_hash[:intensity] = lap.css('Intensity').text
        lap_hash[:trigger_method] = lap.css('TriggerMethod').text
        lap_hash[:trackpoints] = parse_trackpoints(lap)
        lap_hash
      end
    end

    def parse_activities
      doc.css('Activity').map do |activity|
        act_hash = {}
        act_hash[:sport] = activity['Sport']
        act_hash[:id] = activity.css('Id').text
        act_hash[:creator] = activity.css('Creator/Name').text
        act_hash[:laps] = parse_laps(activity)
        act_hash
      end
    end
  end
end
