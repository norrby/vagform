# -*- coding: undecided -*-
class Yfb01EnvelopeKnee < NSButton
  attr_reader :delta_x, :delta_y, :total_x, :total_y

  def mouseDragged(event)
    super
    @delta_x = event.deltaX
    @delta_y = event.deltaY
    sendAction(self.action, to:self.target)
    @total_x += event.deltaX
    @total_y += event.deltaY
  end

  def put_center_on(point)
    kx = bounds.size.width
    ky = bounds.size.height
    xpos = point.x - kx/2
    ypos = point.y - ky/2
    setFrameOrigin(NSPoint.new(xpos, ypos))
  end

  def mouseDown(event)
    @total_x = 0
    @total_y = 0
    sendAction(self.action, to:self.target)
  end

  def awakeFromNib
    @total_x = 0
    @total_y = 0
    setContinuous(true)
    #    sendActionOn(NSLeftMouseDraggedMask)
  end
end
