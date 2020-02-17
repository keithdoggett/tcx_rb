# frozen_string_literal: true

require 'test_helper'

class TrackpointTest < Minitest::Test
  def test_initialize
    tp_data = { time: '2020-02-11T19:40:22.000-05:00',
                latitude: '30', longitude: '-75',
                altitude: '13.2', distance: '100.5',
                heart_rate: '76' }
    tp = TcxRb::Trackpoint.new(tp_data)
    assert_equal(tp_data[:time], tp.time)
    assert_equal(tp_data[:latitude].to_f, tp.latitude)
    assert_equal(tp_data[:longitude].to_f, tp.longitude)
    assert_equal(tp_data[:altitude].to_f, tp.altitude)
    assert_equal(tp_data[:distance].to_f, tp.distance)
    assert_equal(tp_data[:heart_rate].to_i, tp.heart_rate)
  end
end
