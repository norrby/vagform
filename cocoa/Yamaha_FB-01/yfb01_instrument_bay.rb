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
    puts "instrument bay awoke"
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
