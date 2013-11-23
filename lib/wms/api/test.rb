require "wms/namespace"
require "wms/api/event"
require "wms/api/analytic"

class Wms::Api::Test
  include Wms::Api::Event
  include Wms::Api::Analytic

  def print_something(*args)
    puts args
  end

  def test_events
    options = {
      :type => "wifi_accesspoint_info",
      :begin => Time.local(2013, 9, 6),
      :end => Time.now
    }

    set_options(options)

    events do |event|
      print_something(event)
    end
  end

  def test_save_analytics
    data = {"attr1" => "data1", "attr2" => "data2", "attr3" => "data3"}
    save_analytics(data, 5, "widget1", 6)
  end

  def test_get_analytics
    analytics = get_analytics(1)
    analytics.each do |analytic|
      puts analytic
    end
  end

end

