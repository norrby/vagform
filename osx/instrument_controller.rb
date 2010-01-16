class InstrumentController < NSViewController
  attr_accessor :where
  
  def level_changed(sender)
    puts "level: #{sender.intValue}"
  end
	
  def initWithNibName(bundle)
  end
end
