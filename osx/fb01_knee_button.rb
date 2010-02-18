class FB01KneeButton < NSButton
  attr_reader :delta_x, :delta_y

  def mouseDragged(event)
    super
    @delta_x = event.deltaX
    @delta_y = event.deltaY
    sendAction(self.action, to:self.target)
  end

  def put_center_on(point)
    kx = bounds.size.width
    ky = bounds.size.height
    xpos = point.x - kx/2
    ypos = point.y - ky/2
    setFrameOrigin(NSPoint.new(xpos, ypos))
  end

  def mouseDown(event)
  end

  def awakeFromNib
    setContinuous(true)
    #    sendActionOn(NSLeftMouseDraggedMask)
  end
end
