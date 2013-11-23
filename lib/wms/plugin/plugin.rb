class Wms::Plugin::Plugin

  attr_accessor :params
  attr_accessor :logger
  attr_accessor :state
  
  def initialize(params=nil)
    @params = params
    @logger = Logger.new(STDOUT)
  end
  
  def shutdown(queue)
    
  end


  def finished
    
  end

   
end
