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

class Yfb01AlgorithmViewController < NSViewController
  attr_writer :parent_view
  attr_accessor :voice_controller
  attr_accessor :voice_view_controller

  def awakeFromNib
    return unless @parent_view
    @parent_view.addSubview(view)
  end

  def edit_op0(sender)
    @voice_view_controller.edit_op0(sender)
  end

  def edit_op1(sender)
    @voice_view_controller.edit_op1(sender)
  end

  def edit_op2(sender)
    @voice_view_controller.edit_op2(sender)
  end

  def edit_op3(sender)
    @voice_view_controller.edit_op3(sender)
  end

  def press(sender)
  end

end
