require 'Yamaha_FB-01/yfb01_memory_controller'

class Yfb01InstrumentController
  include Yfb01MemoryController
  attr_accessor :name, :voice_controller
  @@Affected = {
    "lower_key_limit" => ["lower_key_limit_name",
                          "upper_key_limit",
                          "upper_key_limit_name"],
    "lower_key_limit_name" => ["lower_key_limit",
                               "upper_key_limit",
                               "upper_key_limit_name"],
    "upper_key_limit" => ["upper_key_limit_name",
                          "lower_key_limit",
                          "lower_key_limit_name"],
    "upper_key_limit_name" => ["upper_key_limit",
                               "lower_key_limit",
                               "lower_key_limit_name"],
  }

  def initialize(model, no)
    puts "initializing model with instance of #{model.class}"
    @model = model
    @name = "Instrument #{no}"
    @voice_controller = Yfb01VoiceController.new(model.voice)
  end

  def also_affected_by_key(key)
    @@Affected[key]
  end

  def model
    return @model
  end
end
