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

# yfb01_instrument_bay.rb
# cocoa
#
# Created by M Norrby on 3/13/10.
# Copyright 2010 __MyCompanyName__. All rights reserved.

class Yfb01InstrumentBay < NSViewController
  attr_writer :parent_view
#  attr_accessor :document
  attr_accessor :instrument_controllers

  def observeValueForKeyPath(keyPath, ofObject:object,
                             change:change, context:context)
    max_idx = @instrument_controllers.arrangedObjects.length - 1
    @instrument_controllers.arrangedObjects.each_with_index do |instr, idx|
      @small_views[max_idx - idx].instrument_controller = instr
    end
  end

  def awakeFromNib
    return unless @instrument_controllers
    @instrument_controllers.addObserver(self, forKeyPath:"arrangedObjects",
                                        options:0, context:nil)
    prev_view |= nil
    @small_views ||= []
    @instrument_controllers.arrangedObjects.reverse_each do |instr|
      small = Yfb01InstrumentSmallViewController.alloc
      @small_views << small
      small.instrument_controller = instr
      small.instrument_controllers = @instrument_controllers
      small.initWithNibName("Yfb01InstrumentSmall", bundle:nil)
      if prev_view
        height = small.view.frame.size.height
        ypos = prev_view.frame.origin.y
        origin = NSPoint.new(small.view.frame.origin.x, ypos + height)
        small.view.setFrameOrigin(origin)
      end
      prev_view = small.view
      @parent_view.addSubview(small.view)
    end
  end
end
