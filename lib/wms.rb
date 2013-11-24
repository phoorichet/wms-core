require "wms/version"

module Wms
  module Config
    autoload :Mixin, 'wms/config/mixin'
  end

  module Input
    autoload :Base, 'wms/input/base'
    autoload :AndroidSensor, 'wms/input/android_sensor'
    autoload :AndroidWifiLocation, 'wms/input/android_wifilocation'
  end

  module Plugin
    autoload :Plugin, 'wms/plugin/plugin'
  end
  
  module Widget 
    autoload :Base, 'wms/widget/base'
  end

  module Api
    autoload :Event, 'wms/api/event'
    autoload :Analytic, 'wms/api/analytic'
  end 
end
