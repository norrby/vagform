require 'Yamaha_FB-01/yfb01_memory_controller'

class Yfb01InstrumentController
  include Yfb01MemoryController
  attr_accessor :name

  def initialize(model, no)
    puts "initializing model with instance of #{model.class}"
    @model = model
    @name = "Instrument #{no}"
  end

  def model
    return @model
  end
end
