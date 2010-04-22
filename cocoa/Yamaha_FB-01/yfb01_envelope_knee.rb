#  .
# VAGFORM, a MIDI Synth Editor
# Copyright (C) 2010  M Norrby
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
