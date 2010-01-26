# -*- coding: undecided -*-
class WaveformView < NSCustomView

  attr_writer :controller
  attr_writer :operator

  class FakeOperator
    attr_reader :tl, :dt1, :ar, :d1r, :d2r, :sl, :rr
    def initialize
      @tl = 0
      @dt1 = 4
      @ar = 20
      @d1r = 20
      @d2r = 25
      @sl = 5
      @rr = 5
    end
    
  end

  def awakeFromNib()
    @op = FakeOperator.new
  end
  
  def mouseDown(event)
#    pa = NSPoint.new(10, 10)
#    @point = convertPoint(evmouent.locationInWindow, fromView:nil)
#    puts "#{@point.x}#{@point.y}"
#    puts "x: #{event.locationInWindow.x}"
#    puts "y: #{event.locationInWindow.y}"
#    setNeedsDisplay(true)
  end

  def mouseDragged(event)
  end

  def drawRect(rect)
  end

  def isFlipped
    false #true
  end

  def drawRect(rect)
    path = NSBezierPath.bezierPath
    path.setLineWidth(4)
    NSBezierPath.setDefaultLineCapStyle(NSRoundLineCapStyle)
    start_point = NSPoint.new(1, 10)
    frame_height = frame.size.height
    top = NSPoint.new(20, frame_height)
    sustain_start = NSPoint.new(30, 10)
    sustain_end = NSPoint.new(40, 10)
    path.moveToPoint(start_point)
    path.lineToPoint(top)
    path.lineToPoint(sustain_start)
    path.lineToPoint(sustain_end)
    #path.closePath
    NSColor.greenColor.set 
    path.stroke
#    start_point = @point || NSPoint.new(1, 1);
#    end_point = NSPoint.new(50, 50)
# NSPoint.new(60, 60);
# 
#    path.moveToPoint(start_point)
# 
#    path.curveToPoint(end_point, controlPoint1:NSPoint.new(20, 41), controlPoint2:NSPoint.new(41, 20))
# 
#    path.closePath
# 
#    NSColor.greenColor.set 
#    path.stroke
  end
end
