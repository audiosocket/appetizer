$:.unshift File.expand_path "./lib"

module App
  def self.env
    (ENV["APP_ENV"] || ENV["RACK_ENV"] || ENV["RAILS_ENV"]).intern
  end

  def self.development?
    :development == env
  end

  def self.production?
    :production == env
  end

  def self.test?
    :test == env
  end
end
