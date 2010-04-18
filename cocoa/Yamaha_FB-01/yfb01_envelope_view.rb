# -*- coding: undecided -*-
class Yfb01EnvelopeView < NSView
  attr_writer :knee1, :knee2, :knee3, :knee4, :knee5
  attr_writer :parent_view
  attr_accessor :operator_controller

  def op(key)
     @operator_controller.selection.valueForKey(key)
  end

  def set_op(key, value)
    @operator_controller.selection.setValue(value, forKey:key)
  end

  def observeValueForKeyPath(keyPath, ofObject:object,
                             change:change, context:context)
    setNeedsDisplay(true)
  end

  def operator_tl
    op("tl")
  end

  def set_tl(value)
    set_op("tl", value)
  end

  def operator_max_tl
    op("max_tl")
  end

  def operator_min_tl
    op("min_tl")
  end

  def operator_ar
    op("ar")
  end

  def set_ar(value)
    set_op("ar", value)
  end

  def operator_max_ar
    op("max_ar")
  end

  def operator_min_ar
    op("min_ar")
  end
 
  def operator_d1r
    op("d1r")
  end

  def set_d1r(value)
    set_op("d1r", value)
  end

  def operator_max_d1r
    op("max_d1r")
  end

  def operator_min_d1r
    op("min_d1r")
  end

  def operator_sl
    op("sl")
  end

  def set_sl(value)
    set_op("sl", value)
  end

  def operator_max_sl
    op("max_sl")
  end

  def operator_min_sl
    op("min_sl")
  end

  def operator_d2r
    op("d2r")
  end

  def set_d2r(value)
    set_op("d2r", value)
  end

  def operator_max_d2r
    op("max_d2r")
  end

  def operator_min_d2r
    op("min_d2r")
  end

  def operator_rr
    op("rr")
  end

  def set_rr(value)
    set_op("rr", value)
  end

  def operator_max_rr
    op("max_rr")
  end

  def operator_min_rr
    op("min_rr")
  end

  def x
    frame.size.width - 3 * margin.x
  end

  def y
    frame.size.height - 3 * margin.y
  end

  def margin
    NSPoint.new(frame.size.width * 0.1, frame.size.height * 0.1)
  end

  def add_margin(point)
    NSPoint.new(point.x + margin.x, point.y + margin.y)
  end

  def button_margin
    return NSPoint.new(7, 7)
  end

  def adjust_tl(point)
    NSPoint.new(point.x, point.y * (1 - (0.0 + operator_tl)/operator_max_tl))
  end

  def ar
    arx = x/4 * (0.0 + operator_ar)/operator_max_ar
    NSPoint.new(arx, y)
  end

  def sl
    slx = x/4 * (0.0 + operator_d1r)/operator_max_d1r + ar.x
    sly = y * (1 - (0.0 + operator_sl)/operator_max_sl)
    NSPoint.new(slx, sly)
  end

  def dr
    dr_ratio = (1 - (0.0 + operator_d2r)/operator_max_d2r)
    dry = sl.y/2 + (sl.y/2) * dr_ratio
    drx = sl.x + x/4 * dr_ratio
    NSPoint.new(drx, dry)
  end

  def rr
    rr_ratio = (0.0 + operator_rr)/operator_max_rr
    rrx = x/4 * rr_ratio + dr.x
    rry = 0
    NSPoint.new(rrx, rry)
  end

  def isFlipped
    false
  end


  def knee1_moved(sender)
  end

  def knee2_moved(sender)
    @saved_ar = operator_ar if sender.total_x == 0
    @saved_tl = operator_tl if sender.total_y == 0
    set_ar(mouse_to_ar(@saved_ar ||= operator_ar, sender.total_x))
    set_tl(mouse_to_tl(@saved_tl ||= operator_tl, sender.total_y))
  end

  def knee3_moved(sender)
    @saved_sl = operator_sl if sender.total_y == 0
    @saved_d1r = operator_d1r if sender.total_x == 0
    set_sl(mouse_to_sl(@saved_sl ||= operator_sl, sender.total_y))
    set_d1r(mouse_to_d1r(@saved_d1r ||= operator_d1r, sender.total_x))
  end

  def knee4_moved(sender)
    @saved_d2r = operator_d2r if sender.total_y == 0 and sender.total_x == 0
    set_d2r(mouse_to_d2r(@saved_d2r ||= operator_d2r, sender.total_x, sender.total_y))
  end

  def knee5_moved(sender)
    @saved_rr = operator_rr if sender.total_x == 0
    set_rr(mouse_to_rr(@saved_rr ||= operator_rr, sender.total_x))
  end

  def moderate(ratio, old_value, min, max)
    value = old_value + (ratio * max)
    return min if value < min
    return max if value > max
    value.to_i
  end

  def mouse_to_ar(old_ar, xmove) 
    ratio = xmove / (x/4)
    moderate(ratio, old_ar, operator_min_ar, operator_max_ar)
 end

  def mouse_to_sl(old_sl, ymove)
    ratio = ymove / y
    moderate(ratio, old_sl, operator_min_sl, operator_max_sl)
  end

  def mouse_to_d1r(old_d1r, xmove)
    ratio = xmove / (x/4)
    moderate(ratio, old_d1r, operator_min_d1r, operator_max_d1r)
  end

  def mouse_to_d2r(old_d2r, xmove, ymove)
    yratio = ymove / (sl.y/2)
    xratio = -xmove / (x/4)
    dr_ratio = (xratio + yratio)/2
    moderate(dr_ratio, old_d2r, operator_min_d2r, operator_max_d2r)
  end

  def mouse_to_rr(old_rr, xmove)
    ratio = xmove / (x/4)
    moderate(ratio, old_rr, operator_min_rr, operator_max_rr)
  end    

  def mouse_to_tl(old_tl, ymove)
    ratio = ymove / y
    moderate(ratio, old_tl, operator_min_tl, operator_max_tl)
  end

  def border
    sl_point = sl
    dr_point = dr
    return NSPoint.new(sl_point.x, 0) if sl_point.x == dr_point.x
    slope = (dr_point.y - sl_point.y)/(dr_point.x - sl_point.x)
    new_y = dr_point.y + slope * (x - dr_point.x)
    return NSPoint.new(x, new_y) if (new_y > 0) 
    new_x = dr_point.x - dr_point.y/slope
    return NSPoint.new(new_x, 0)
  end

  def drawGrid
    NSColor.colorWithCalibratedWhite(1, alpha:1).set
    step = bounds.size.width/10
    xpos = step
    grid = NSBezierPath.bezierPath
    grid.setLineWidth(0.3)
    9.times do
      start = NSPoint.new(xpos, button_margin.y)
      grid.moveToPoint(start)
      stop = NSPoint.new(xpos, bounds.size.height - button_margin.y)
      grid.lineToPoint(stop)
      xpos += step
    end
    step = bounds.size.height/10
    ypos = step
    9.times do
      start = NSPoint.new(button_margin.x, ypos)
      grid.moveToPoint(start)
      stop = NSPoint.new(bounds.size.width - button_margin.x, ypos)
      grid.lineToPoint(stop)
      ypos += step
    end
    grid.stroke
  end

  def drawRect(rect)
    super
    drawGrid
    wave = NSBezierPath.bezierPath
    wave.setLineWidth(3)
    orig = add_margin(NSPoint.new(0, 0))
    wave.moveToPoint(orig)
    [ar, sl, dr, rr].each do |point|
      wave.lineToPoint(add_margin(adjust_tl(point)))
    end
    @knee1.put_center_on(orig)
    @knee2.put_center_on(add_margin(adjust_tl(ar)))
    @knee3.put_center_on(add_margin(adjust_tl(sl)))
    @knee4.put_center_on(add_margin(adjust_tl(dr)))
    @knee5.put_center_on(add_margin(adjust_tl(rr)))
    NSColor.greenColor.set
    wave.stroke
    dash = NSBezierPath.bezierPath
    dash.setLineWidth(3)
    dash.moveToPoint(add_margin(adjust_tl(dr)))
    dash.lineToPoint(add_margin(adjust_tl(border)))
#    NSColor.blueColor.set
    dash.setLineDash([5, 2], count:2, phase:0.0)
    dash.stroke
    self
  end

  def awakeFromNib
    ["tl", "ar", "d1r", "d2r", "sl", "rr"].each do |prop|
      @operator_controller.addObserver(self, forKeyPath:"selection.#{prop}", options:0, context:nil)
    end
  end

end
