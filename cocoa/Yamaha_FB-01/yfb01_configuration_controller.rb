require 'Yamaha_FB-01/yfb01_memory_controller'

class Yfb01ConfigurationController
  include Yfb01MemoryController

  def initialize(model)
    puts "initializing model with instance of #{model.class}"
    @model = model
  end

  def model
    return @model
  end
end
