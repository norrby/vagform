# -*- coding: undecided -*-
class WaveformView < NSCustomView

  attr_writer :controller

  def mouseDown(event)
#    pa = NSPoint.new(10, 10)
    @point = convertPoint(event.locationInWindow, fromView:nil)
#    puts "#{@point.x}#{@point.y}"
    setNeedsDisplay(true)
  end

  def mouseDragged(event)
  end

  def drawRect(rect)
    path = NSBezierPath.bezierPath
    path.setLineWidth(4)
    NSBezierPath.setDefaultLineCapStyle(NSRoundLineCapStyle)
    start_point = @point || NSPoint.new(1, 1);
    end_point = NSPoint.new(50, 50)
#NSPoint.new(60, 60);

    path.moveToPoint(start_point)

    path.curveToPoint(end_point, controlPoint1:NSPoint.new(20, 41), controlPoint2:NSPoint.new(41, 20))

    path.closePath

    NSColor.greenColor.set 
    path.stroke
  end
end
