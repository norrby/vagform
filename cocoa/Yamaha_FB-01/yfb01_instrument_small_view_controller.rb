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

require 'Yamaha_FB-01/yfb01_memory_controller'

class Yfb01InstrumentSmallViewController < NSViewController
  attr_writer :instrument_controllers
  attr_writer :indicator
  attr_accessor :instr
  attr_writer :box

  def select_me(sender)
    @instrument_controllers.setSelectedObjects([instrument_controller])
  end

  def awakeFromNib 
    @instrument_controllers.addObserver(self, forKeyPath:"selection",
                                        options:0, context:nil)
    @box.setTitle("#{@instr.name} notes and MIDI channel")
  end

  def instrument_controller=(ctrl)
    willChangeValueForKey("instr")
    @instr = ctrl
    didChangeValueForKey("instr")
  end

  def instrument_controller
    @instr
  end

  def observeValueForKeyPath(keyPath, ofObject:object,
                             change:change, context:context)
    if @instrument_controllers.selectedObjects[0] == instrument_controller
      @instrument_controller = instrument_controller
      selected = 1
    else
      selected = 0
    end
    @indicator.setState selected
  end
end
