class FB01EnvelopeEditor < NSView
  attr_writer :knee1, :knee2, :knee3, :knee4, :knee5
  attr_writer :provider

  def operator
    @provider.model
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

  def adjust_tl(point)
    NSPoint.new(point.x, point.y * (1 - (0.0 + operator.tl)/operator.max_tl))
  end

  def ar
    arx = x/4 * (0.0 + operator.ar)/operator.max_ar
    NSPoint.new(arx, y)
  end

  def sl
    slx = x/4 * (0.0 + operator.d1r)/operator.max_d1r + ar.x
    sly = y * (1 - (0.0 + operator.sl)/operator.max_sl)
    NSPoint.new(slx, sly)
  end

  def dr
    dr_ratio = (1 - (0.0 + operator.d2r)/operator.max_d2r)
    dry = sl.y/2 + (sl.y/2) * dr_ratio
    drx = sl.x + x/4 * dr_ratio
    NSPoint.new(drx, dry)
  end

  def rr
    rr_ratio = (0.0 + operator.rr)/operator.max_rr
    rrx = x/4 * rr_ratio + dr.x
    rry = 0
    NSPoint.new(rrx, rry)
  end

  def isFlipped
    false
  end

  def button_margin
    return NSPoint.new(7, 7)
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

  def awakeFromNib
    operator.subscribe(self, :invalidate)
  end

  def invalidate(operator)
    setNeedsDisplay(true)
  end

  def knee1_moved(sender)
  end

  def moderate(ratio, old_value, min, max)
    value = old_value + (ratio * max)
    return min if value < min
    return max if value > max
    value.to_i
  end

  def mouse_to_ar(old_ar, xmove) 
    ratio = xmove / (x/4)
    moderate(ratio, old_ar, operator.min_ar, operator.max_ar)
 end

  def mouse_to_sl(old_sl, ymove)
    ratio = ymove / y
    moderate(ratio, old_sl, operator.min_sl, operator.max_sl)
  end

  def mouse_to_d1r(old_d1r, xmove)
    ratio = xmove / (x/4)
    moderate(ratio, old_d1r, operator.min_d1r, operator.max_d1r)
  end

  def mouse_to_d2r(old_d2r, xmove, ymove)
    yratio = ymove / (sl.y/2)
    xratio = -xmove / (x/4)
    dr_ratio = (xratio + yratio)/2
    moderate(dr_ratio, old_d2r, operator.min_d2r, operator.max_d2r)
  end

  def mouse_to_rr(old_rr, xmove)
    ratio = xmove / (x/4)
    moderate(ratio, old_rr, operator.min_rr, operator.max_rr)
  end    

  def mouse_to_tl(old_tl, ymove)
    ratio = ymove / y
    moderate(ratio, old_tl, operator.min_tl, operator.max_tl)
  end

  def knee2_moved(sender)
    @saved_ar = operator.ar if sender.total_x == 0
    @saved_tl = operator.tl if sender.total_y == 0
    operator.ar = mouse_to_ar(@saved_ar ||= operator.ar, sender.total_x)
    operator.tl = mouse_to_tl(@saved_tl ||= operator.tl, sender.total_y)
  end

  def knee3_moved(sender)
    @saved_sl = operator.sl if sender.total_y == 0
    @saved_d1r = operator.d1r if sender.total_x == 0
    operator.sl = mouse_to_sl(@saved_sl ||= operator.sl, sender.total_y)
    operator.d1r = mouse_to_d1r(@saved_d1r ||= operator.d1r, sender.total_x)
  end

  def knee4_moved(sender)
    @saved_d2r = operator.d2r if sender.total_y == 0 and sender.total_x == 0
    operator.d2r = mouse_to_d2r(@saved_d2r ||= operator.d2r, sender.total_x, sender.total_y)
  end

  def knee5_moved(sender)
    @saved_rr = operator.rr if sender.total_x == 0
    operator.rr = mouse_to_rr(@saved_rr ||= operator.rr, sender.total_x)
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
end
