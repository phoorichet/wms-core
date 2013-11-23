require 'active_support/concern'
require 'wms/config/mixin'

module Wms::Api::Analytic
  extend ActiveSupport::Concern
  include Wms::Config::Mixin
  
  def get_analytics(wid)
    analytics = Analytic.where(widget_id: wid)
    return analytics
  end

  def save_analytics(data)
    # config = source("lib/wms/widget/" + wname + "/config.yml")
    # attr_name = config[:development][:attributes]

    # Check whether attributes match the ones in config file
    # attr_name.each do |attr|
    #   if data.has_key?(attr)
    #     analytic.write_attribute(attr, data[attr])
    #   else
    #     raise "config file mismatch"
    #   end
    # end  
    analytic = Analytic.new
    data.each do |key, value|
      analytic.write_attribute(key, value)
    end
    analytic.save
    
  end

  module ClassMethod

  end
end

