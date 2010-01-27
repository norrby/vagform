# -*- coding: undecided -*-
class WaveformKnee < NSButton
  attr_reader :x, :y, :delta_x, :delta_y

  def awakeFromNib()
    @x = 10
    @y = 10
    setFrameOrigin(NSPoint.new(@x, @y))
    sendActionOn(NSLeftMouseDraggedMask|NSLeftMouseDownMask)
    setContinuous(true)
  end
  
  def mouseDown(event)
    pa = NSPoint.new(10, 10)
    @point = convertPoint(event.locationInWindow, fromView:nil)
    puts "#{@point.x}#{@point.y}"
    puts "x: #{event.locationInWindow.x}"
    puts "y: #{event.locationInWindow.y}"
    setNeedsDisplay(true)
  end

  def mouseDragged(event)
    @x += event.deltaX
    @y -= event.deltaY
    @delta_x = event.deltaX
    puts "x = #{@x} (deltaX = #{event.deltaX})"
    puts "y = #{@y} (deltaY = #{event.deltaY})"
#    new_pos = (origin.x + event.deltaX, origin.y + event.deltaY)
 #   setFrameOrigin(NSPoint.new(@x, @y))
    setNeedsDisplay(true)
   sendAction(action, to:target)
   
  end

end
