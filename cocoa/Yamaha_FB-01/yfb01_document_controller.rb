# document_controller.rb
# cocoa
#
# Created by M Norrby on 3/6/10.
# Copyright 2010 __MyCompanyName__. All rights reserved.

class Yfb01DocumentController < NSViewController
  attr_accessor :document
  attr_writer :parent_view

  def fetch_from_fb01(sender)
    @document.reset_config
  end

  def select_midi_device(sender)
    @document.communicator.open(sender.selectedItem)
  end

  def select_system_channel(sender)
    @document.communicator.system_channel = sender.intValue
  end

  def awakeFromNib
    @parent_view.addSubview(view) if view
  end
end
