

class FB01OperatorButton < NSButton
  attr_writer :algorithm

  def awakeFromNib
    setButtonType(NSMomentaryPushInButton)
    setTitle("")
    setBezelStyle(NSThickerSquareBezelStyle)
    operator.subscribe(self, :notify)
  end

  def notify(operator)
    setNeedsDisplay(true)
  end

  def operator
    @algorithm.operator(self)
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

  def ar
    arx = x/4 * (1 - (0.0 + operator.ar)/operator.max_ar)
    NSPoint.new(operator.ar, y)
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
  
  def mouseDown(event)
    super
    return unless enabled?
    if not @edit_window
      @edit_window = FB01OperatorDetails.alloc.initWithWindowNibName("OperatorDetails")
    end
    @edit_window.new_model(operator)
    @edit_window.showWindow(self)
  end

  def add_margin(point)
    NSPoint.new(point.x + margin.x, point.y + margin.y)
  end

  def adjust_tl(point)
    NSPoint.new(point.x, point.y * (1 - (0.0 + operator.tl)/operator.max_tl))
  end

  def button_margin
    return NSPoint.new(7, 7)
  end

  def keep_button_bevel
    NSRect.new(NSPoint.new(bounds.origin.x + button_margin.x,
                           bounds.origin.y + button_margin.y),
               NSSize.new(bounds.size.width - 2 * button_margin.x,
                          bounds.size.height - 2 * button_margin.y))
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
    self
  end
end
