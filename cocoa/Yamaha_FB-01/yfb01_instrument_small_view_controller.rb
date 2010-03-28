require 'Yamaha_FB-01/yfb01_memory_controller'

class Yfb01InstrumentSmallViewController < NSViewController
  attr_writer :instrument_controllers
  attr_writer :indicator
  attr_accessor :instr

  def select_me(sender)
    puts "selecting myself"
    @instrument_controllers.setSelectedObjects([instrument_controller])
  end

  def awakeFromNib 
    @instrument_controllers.addObserver(self, forKeyPath:"selection",
                                        options:0, context:nil)
  end

  def instrument_controller=(ctrl)
    willChangeValueForKey("instr")
    @instr = ctrl
    didChangeValueForKey("instr")
  end

  def instrument_controller
    @instr
  end

  def observeValueForKeyPath(keyPath, ofObject:object,
                             change:change, context:context)
    puts "keyPath: #{keyPath} changed"
    if @instrument_controllers.selectedObjects[0] == instrument_controller
      @instrument_controller = instrument_controller
      selected = 1
    else
      selected = 0
    end
    @indicator.setState selected
  end
end
