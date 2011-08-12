require 'rosie/config'
require 'rosie/version'

module Rosie
  class Config
    attr_accessor :key
  end

  def self.config
    @@config ||= Config.new
  end

  def self.configure
    yield self.config
  end
end

