# frozen_string_literal: true

require 'test_helper'

TCX_STR = File.read('./test/data/test_data.tcx')
class ParserTest < Minitest::Test
  def test_parser_loads_doc
    parser = TcxRb::Parser.new(TCX_STR)
    assert_equal(Nokogiri::XML::Document, parser.doc.class)
  end

  def test_parser_parse_trackpoints
    parser = TcxRb::Parser.new(TCX_STR)
    trackpoints = parser.parse_trackpoints
    assert_equal(8, trackpoints.size)
    assert_equal('2020-02-11T21:44:03.000-05:00', trackpoints[0][:time])
    assert_equal('39.96274161338806', trackpoints[0][:latitude])
    assert_equal('-75.17718994617462', trackpoints[0][:longitude])
    assert_equal('8.071420612508698', trackpoints[0][:altitude])
    assert_equal('0.0', trackpoints[0][:distance])
    assert_equal('146', trackpoints[0][:heart_rate])
  end

  def test_parser_parse_trackpoints_with_input
    parser = TcxRb::Parser.new(TCX_STR)

    # parse the second lap
    second_lap = parser.doc.css('Lap')[1]
    trackpoints = parser.parse_trackpoints(second_lap)
    assert_equal(2, trackpoints.size)
    assert_equal('2020-02-11T21:45:03.000-05:00', trackpoints[0][:time])
    assert_equal('40.96274161338806', trackpoints[0][:latitude])
    assert_equal('-76.17718994617462', trackpoints[0][:longitude])
    assert_equal('9.071420612508698', trackpoints[0][:altitude])
    assert_equal('1.0', trackpoints[0][:distance])
    assert_equal('147', trackpoints[0][:heart_rate])
  end

  def test_parser_parse_laps
    parser = TcxRb::Parser.new(TCX_STR)
    laps = parser.parse_laps
    assert_equal(4, laps.size)
    assert_equal('2020-02-11T19:40:22.000-05:00', laps[0][:start_time])
    assert_equal('1915.0', laps[0][:total_time])
    assert_equal('5782.82', laps[0][:distance])
    assert_equal('456', laps[0][:calories])
    assert_equal('Active', laps[0][:intensity])
    assert_equal('Manual', laps[0][:trigger_method])
    assert_equal(2, laps[0][:trackpoints].size)
  end

  def test_parser_parse_laps_with_input
    parser = TcxRb::Parser.new(TCX_STR)
    second_activity = parser.doc.css('Activity')[1]
    laps = parser.parse_laps(second_activity)
    assert_equal(2, laps.size)
    assert_equal('2020-03-11T19:40:22.000-05:00', laps[0][:start_time])
    assert_equal('2015.0', laps[0][:total_time])
    assert_equal('6782.82', laps[0][:distance])
    assert_equal('556', laps[0][:calories])
    assert_equal('Active', laps[0][:intensity])
    assert_equal('Auto', laps[0][:trigger_method])
    assert_equal(2, laps[0][:trackpoints].size)
  end

  def test_parser_parse_activities
    parser = TcxRb::Parser.new(TCX_STR)
    activities = parser.parse_activities
    assert_equal(2, activities.size)
    assert_equal('Running', activities[0][:sport])
    assert_equal('2020-02-11T19:40:22.000-05:00', activities[0][:id])
    assert_equal('Fitbit Ionic', activities[0][:creator])
    assert_equal(2, activities[0][:laps].size)
  end
end
