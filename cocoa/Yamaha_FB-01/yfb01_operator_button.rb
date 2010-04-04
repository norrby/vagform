class Yfb01OperatorButton < NSButton
  attr_writer :operator_controller_container

  def observeValueForKeyPath(keyPath, ofObject:object,
                             change:change, context:context)
    setNeedsDisplay(true)
  end

  def op(key)
    @operator_controller_container.selection.valueForKey(key)
  end

  def keep_button_bevel
    NSRect.new(NSPoint.new(bounds.origin.x + button_margin.x,
                           bounds.origin.y + button_margin.y),
               NSSize.new(bounds.size.width - 2 * button_margin.x,
                          bounds.size.height - 2 * button_margin.y))
  end

  def add_margin(point)
    NSPoint.new(point.x + margin.x, point.y + margin.y)
  end

  def adjust_tl(point)
    NSPoint.new(point.x, point.y * (1 - (0.0 + mod_tl)/mod_max_tl))
  end

  def margin
    NSPoint.new(frame.size.width * 0.1, frame.size.height * 0.1)
  end

  def button_margin
    return NSPoint.new(7, 7)
  end

  def x
    frame.size.width - 3 * margin.x
  end

  def y
    frame.size.height - 3 * margin.y
  end

  def mod_tl
    op("tl")
  end

  def mod_max_tl
    op("max_tl")
  end

  def mod_ar
    op("ar")
  end

  def mod_max_ar
    op("max_ar")
  end

  def mod_d1r
    op("d1r")
  end

  def mod_max_d1r
    op("max_d1r")
  end

  def mod_d2r
    op("d2r")
  end

  def mod_max_d2r
    op("max_d2r")
  end

  def mod_sl
    op("sl")
  end

  def mod_max_sl
    op("max_sl")
  end

  def mod_rr
    op("rr")
  end

  def mod_max_rr
    op("max_rr")
  end

  def ar
    arx = x/4 * (1 - (0.0 + mod_ar)/mod_max_ar)
    NSPoint.new(mod_ar, y)
  end

  def sl
    slx = x/4 * (0.0 + mod_d1r)/mod_max_d1r + ar.x
    sly = y * (1 - (0.0 + mod_sl)/mod_max_sl)
    NSPoint.new(slx, sly)
  end

  def dr
    dr_ratio = (1 - (0.0 + mod_d2r)/mod_max_d2r)
    dry = sl.y/2 + (sl.y/2) * dr_ratio
    drx = sl.x + x/4 * dr_ratio
    NSPoint.new(drx, dry)
  end

  def rr
    rr_ratio = (0.0 + mod_rr)/mod_max_rr
    rrx = x/4 * rr_ratio + dr.x
    rry = 0
    NSPoint.new(rrx, rry)
  end

  def isFlipped
    false
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
    NSColor.colorWithCalibratedWhite(0.2, alpha:1).set
    NSBezierPath.bezierPathWithRect(keep_button_bevel).fill
    drawGrid
    wave = NSBezierPath.bezierPath
    wave.setLineWidth(3)
    wave.moveToPoint(add_margin(NSPoint.new(0, 0)))
    [NSPoint.new(0, 0), ar, sl, dr, rr].each do |point|
      wave.lineToPoint(add_margin(adjust_tl(point)))
    end
    NSColor.greenColor.set
    wave.stroke
  end

  def awakeFromNib
    return unless @operator_controller_container
    setButtonType(NSMomentaryPushInButton)
    setTitle("")
    setBezelStyle(NSThickerSquareBezelStyle)
    ["tl", "ar", "d1r", "d2r", "sl", "rr"].each do |prop|
      @operator_controller_container.addObserver(self,
                                              forKeyPath:"selection.#{prop}",
                                              options:0, context:nil)
    end
 end
end
