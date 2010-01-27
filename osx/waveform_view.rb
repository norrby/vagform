# -*- coding: undecided -*-
class WaveformView < NSCustomView
  attr_writer :controller
  attr_writer :operator

  def awakeFromNib()
  end
  
  def mouseDown(event)
    pa = NSPoint.new(10, 10)
    @point = convertPoint(event.locationInWindow, fromView:nil)
    puts "#{@point.x}#{@point.y}"
    puts "x: #{event.locationInWindow.x}"
    puts "y: #{event.locationInWindow.y}"
  end

  def mouseDragged(event)
  end
  def isFlipped
    false #true
  end

  def drawRect(rect)
    path = NSBezierPath.bezierPath
    path.setLineWidth(4)
    NSBezierPath.setDefaultLineCapStyle(NSRoundLineCapStyle)
    ar_origin = @operator.frame.origin
    ar_size = @operator.bounds.size
    ar = NSPoint.new(ar_origin.x + ar_size.width/2,
                     ar_origin.y + ar_size.height/2, )
    start_point = NSPoint.new(ar_size.width/2, 0)
    path.moveToPoint(start_point)
    path.lineToPoint(ar)
    #path.closePath
    NSColor.greenColor.set 
    path.stroke
    setNeedsDisplay(true)

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
