require 'wms/input/base'
require 'wms/config/mixin'
require 'csv'
require 'time'

class Wms::Input::AndroidWifiLocation < Wms::Input::Base

  attr_accessor :filepath


  public
  def register(options={})
    raise "#{self.class.name}: filepath required in options" unless options[:filepath]
    @filepath   = options[:filepath]
    @compressed = options[:compressed]
    @file_ext   = options[:file_ext]
    @is_gz      = options[:file_ext] == '.gz'
    
  end # def register

  # Read from csv file row by row. Callback function will be called when each 
  # row is done reading.
  public
  def run(&block)
    # adding options to make data manipulation easy
    total_lines = 0
    str_arr = []
    if @is_gz
      Zlib::GzipReader.open(@filepath) do |csv|
        csv.read.each_line do |line|
          str_arr = []
          str_arr << '['
          str_arr << line
          str_arr << ']'
          joined_str = str_arr.join("")
          json_obj = JSON.parse(joined_str)

          norm_json = normlaize_json_obj(json_obj)
          callback = block
          callback.call(norm_json)
          # @logger.debug ">>>>>>#{norm_json}"

          total_lines += 1
        end
      end

      @logger.debug "Total line: %d" % total_lines
    else
      File.open(@filepath, "r").each_line do |line|
        str_arr = []
        str_arr << '['
        str_arr << line
        str_arr << ']'
        joined_str = str_arr.join("")
        json_obj = JSON.parse(joined_str)

        norm_json = normlaize_json_obj(json_obj)
        callback = block
        callback.call(norm_json)
        # @logger.debug ">>>>>>#{norm_json}"

        total_lines += 1
      end
    end

  end # end run(&block)


  #
  private
  def normlaize_json_obj(json_obj)
    normlaized_json_obj = {}
    if json_obj[0] == 'wifi_accesspoint_info' 
      normlaized_json_obj['type'] = 'wifi_accesspoint_info'
      normlaized_json_obj['timestamp'] = Time.at(json_obj[2] / 1000.0, json_obj[2] % 1000.0)
      normlaized_json_obj['device_id'] = json_obj[3]
      normlaized_json_obj['wifi_list'] = json_obj[4]['list']

      # Convert string values into floats
      convert_level_freq(normlaized_json_obj['wifi_list'])


      
    elsif json_obj[0] == 'location'
      normlaized_json_obj['type'] = 'location'
      normlaized_json_obj['timestamp'] = Time.at(json_obj[2] / 1000.0, json_obj[2] % 1000.0)
      normlaized_json_obj['device_id'] = json_obj[3]
      stop_at = json_obj.length - 1
      range = (4..stop_at)
      range.step(2).each do |i|
        normlaized_json_obj[json_obj[i]] = json_obj[i+1]
      end
      # @logger.debug normlaized_json_obj
    end
              
    return normlaized_json_obj
  end

  private
  def convert_level_freq(wifi_list)
    wifi_list.each do |wifi|
      wifi['level'] = wifi['level'].to_i if wifi['level']
      wifi['frequency'] = wifi['frequency'].to_i if wifi['frequency']
    end
  end

end
