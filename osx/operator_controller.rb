class OperatorController < NSViewController
  attr_writer :button1, :button2
  attr_writer :where
  
  def tl_changed(sender)
    puts "tl is"
  end
  
  def awakeFromNib
    @where.addSubview(view)
    puts "fasandeR2"
    #view.setFrameOrigin(NSPoint.new(0.0, 0.0))
  end

  def sendEvent(event)
    puts event
  end

  def dragImage(at, offset, event,pasteboard, source, slideBack)
    puts "dragging"
  end
end
