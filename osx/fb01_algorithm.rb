require 'observable'
require 'model_enabled'
require 'model_bindings'

class FB01Algorithm < NSViewController
  include Observable
  include ModelEnabled
  include ModelBindings
  attr_writer :op1, :op2, :op3, :op4
  attr_writer :tab, :feedback_level_indicator
  attr_writer :voice_controller

  def operators
    @voice_controller.operators
  end

  def operator_controllers
    return @operator_controllers if @operator_controllers
    if (@op1 and @op2 and @op3 and @op4)
      return @operator_controllers = [@op1, @op2, @op3, @op4]
    end
    nil
  end

  def operator(for_controller)
    operators[operator_controllers.index(for_controller)]
  end

  def null_model
    Voice.null
  end

  def invalidate(voice)
    @feedback_level_indicator.setIntValue(voice.feedback)
  end

  def voice_changed(voice_controller)
    new_model(voice_controller.model)
    notify_observers
  end

  def awakeFromNib
    @tab.setView(view)
    @voice_controller.subscribe(self, :voice_changed)
  end
end
