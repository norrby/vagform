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

# yfb01_configuration_view_controller.rb
# cocoa
#
# Created by M Norrby on 3/7/10.
# Copyright 2010 __MyCompanyName__. All rights reserved.

class Yfb01ConfigurationViewController < NSViewController
  attr_writer :parent_view
  attr_accessor :document

  def set_odd(sender)
    @document.configuration.setValue(sender.intValue, forKey:"kc_reception_odd")
  end

  def set_even(sender)
    @document.configuration.setValue(sender.intValue, forKey:"kc_reception_even")
  end

  def awakeFromNib
    @parent_view.addSubview(view) if view
  end

end
