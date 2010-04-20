class Yfb01EnvelopeViewController < NSViewController
  attr_writer :knee1, :knee2, :knee3, :knee4, :knee5
  attr_writer :parent_view
  attr_accessor :operator_editor

  def op(key)
    @operator_editor.operator_controller.selection.valueForKey(key)
  end

  def observeValueForKeyPath(keyPath, ofObject:object,
                             change:change, context:context)
    setNeedsDisplay(true)
  end

  def operator_tl
    op("tl")
  end

  def operator_max_tl
    op("max_tl")
  end

  def operator_ar
    op("ar")
  end

  def operator_max_ar
    op("max_ar")
  end

  def operator_d1r
    op("d1r")
  end

  def operator_max_d1r
    op("max_d1r")
  end

  def operator_sl
    op("sl")
  end

  def operator_max_sl
    op("max_sl")
  end

  def operator_d2r
    op("d2r")
  end

  def operator_max_d2r
    op("max_d2r")
  end

  def operator_rr
    op("rr")
  end

  def operator_max_rr
    op("max_rr")
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
    puts "envelope_view_controller awoke"
#    return unless @parent_view
#    @parent_view.addSubview(view)
    ["tl", "ar", "d1r", "d2r", "sl", "rr"].each do |prop|
      puts "registering for #{prop}"
      @operator_editor.operator_controller.addObserver(self, forKeyPath:"selection.#{prop}", options:0, context:nil)
    end
  end

end
