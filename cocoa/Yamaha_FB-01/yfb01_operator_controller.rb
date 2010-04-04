require 'yfb01_memory_controller'

class Yfb01OperatorController
  include Yfb01MemoryController
  attr_accessor :model

  def initialize(model)
    @model = model
  end
end
