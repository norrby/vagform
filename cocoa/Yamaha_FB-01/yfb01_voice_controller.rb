require 'Yamaha_FB-01/yfb01_memory_controller'

class Yfb01VoiceController
  include Yfb01MemoryController
  attr_reader :model
  attr_reader :op1_controller, :op2_controller, :op3_controller, :op4_controller

  def initialize(model)
    @model = model
    @op1_controller, @op2_controller, @op3_controller, @op4_controller = model.operators.collect {|op| Yfb01OperatorController.new(op)}
  end

end
