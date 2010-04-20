require 'Yamaha_FB-01/yfb01_memory_controller'
require 'Yamaha_FB-01/yfb01_instrument_controller'

class Yfb01ConfigurationController
  include Yfb01MemoryController
  attr_accessor :instrument_controllers

  def initialize(model)
    @model = model
    instr_no = 0
    @instrument_controllers = model.instruments.collect do |instr|
      Yfb01InstrumentController.new(instr, instr_no += 1)
    end
  end

  def model
    return @model
  end
end
