require 'active_support/concern'

module Wms::Api::Event
  # Looks for ClassMethods to be included
  extend ActiveSupport::Concern

  attr_accessor :options

  #private
  attr_accessor :events
 
  # Get called when included
  included do
    # Nothing to include for now
    init
    puts "Init event...\n\n"
  end

  def initialize
    super
    @events = Event
  end

  def get_events(options={})
    # events = Event.all_in(device_id: options[:device_id],
    #   type: options[:type]).between(timestamp: options[:begin]..options[:end]).order_by(:timestamp.asc)
    # events_hash = []
    # if events.length > 0
    #   events.each do |e|
    #     events_hash.push(Hash[e.attributes])
    #   end
    # end
    # 
    # events_hash
    Event.where(options) 
  end

  module ClassMethods
        
    def init
    end

  end

end
