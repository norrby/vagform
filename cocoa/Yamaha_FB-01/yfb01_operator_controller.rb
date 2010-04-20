require 'Yamaha_FB-01/yfb01_memory_controller'

class Yfb01OperatorController
  include Yfb01MemoryController
  attr_accessor :model

  def initialize(model)
    @model = model
  end
end
