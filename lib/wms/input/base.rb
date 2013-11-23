require 'wms/plugin/plugin'
require 'wms/config/mixin'

class Wms::Input::Base < Wms::Plugin::Plugin
  include Wms::Config::Mixin

  attr_accessor :tags

  public
  def initialize(options={})
    super
    @threadable = false
    @tags ||= []

    @logger = Logger.new(STDOUT)

  end # def initialize

  # This method sets up the configurations for the derived classes.
  # This mothod must be called so that the configuration can be created.
  # @params:
  # => options: optional configurations
  #
  # @required
  public
  def register(options={})
    raise "#{self.class}#register must be overidden"
  end # def register

  # The method will be called to processs the logics. The queue 
  # @params:
  # => queue: a queue for the class to add the end result
  #
  # @required
  public
  def run(&block)
    raise "#{self.class}#run must be overidden"
  end

  # An options 
  public
  def tag(newtag)
    @tags << newtag
  end # def tag
  
end