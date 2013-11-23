require "wms/version"

module Wms
  puts "Loading WMS..."
  module Input;  end
  module Config; end
  module Plugin; end
  module Widget; end
  module Api; end 
end

require 'wms/config/mixin'
require 'wms/input/base'
