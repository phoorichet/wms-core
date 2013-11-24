require 'wms/input/base'
require 'wms/config/mixin'
require 'csv'
require 'time'

class Wms::Input::AndroidSensor < Wms::Input::Base
  # Header must be defined
  set_default :headers, :type => Array, :default => [
        :timestamp,
        :accelerometer_x,
        :accelerometer_y,
        :accelerometer_z,
        :orientation_disabled_x,
        :orientation_isabled_y,
        :orientation_isabled_z,
        :compass_disabled_x,
        :compass_disabled_y,
        :compass_disabled_z,
        :gyro_x,
        :gyro_y,
        :gyro_z,
        :temperature_not_supported,
        :light
      ]

  # Convert the field to numeric by default
  set_default :converters, :type => Array, :default => [ :numeric ]

  attr_accessor :filepath, :headers

  public
  def register(options={})
    raise "#{self.class.name}: filepath required in options" unless options[:filepath]
    @filepath   = options[:filepath]
    @headers    = self.class.get_default(:headers)
    @converters = self.class.get_default(:converters)
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
    if @is_gz
      Zlib::GzipReader.open(@filepath) do |csv|
        CSV.parse( csv.read, { :headers => @headers, 
                                  :converters => @converters
                                  }) do |line|

          # @logger.debug line.to_hash

          # Covert timestamp field from epoc time to Time object.
          # Time object also include microsecond as the second arg.
          data = line.to_hash

          # Skip the first row
          if total_lines != 0
            begin
              data[:timestamp] = Time.at(data[:timestamp] / 1000, data[:timestamp] % 1000)
              data[:type] = 'sensor'

              # Call the callback function with the hash as params
              callback = block
              callback.call(data)
            rescue Exception => e
              @logger.error "ERROR #{self.class.name} while parsing #{e}"
            end
            
          end

          total_lines += 1
        end

      end
    else
      CSV.foreach( @filepath, { :headers => @headers, 
                                :converters => @converters
                                }) do |line|

        # @logger.debug line.to_hash

        # Covert timestamp field from epoc time to Time object.
        # Time object also include microsecond as the second arg.
        data = line.to_hash

        # Skip the first row
        if total_lines != 0
          begin
            data[:timestamp] = Time.at(data[:timestamp] / 1000, data[:timestamp] % 1000)
            data[:type] = 'sensor'

            # Call the callback function with the hash as params
            callback = block
            callback.call(data)
          rescue Exception => e
            @logger.error "ERROR #{self.class.name} while parsing #{e}"
          end
          
        end

        total_lines += 1
      end
    end
    @logger.debug "Total line: %d" % total_lines
  end

end
