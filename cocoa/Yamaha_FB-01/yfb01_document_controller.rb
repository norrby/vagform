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
