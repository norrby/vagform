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
module PmdControllers
  @@PmdControllers = ["Not assigned", "After touch",
                      "Modulation wheel", "Breath controller", "Foot controller"]

  def pmd_controller
    @@PmdControllers[pmd_controller_no]
  end

  def pmd_controller=(controller_name)
    if not idx = @@PmdControllers.index(controller_name)
      raise "There is no \"#{controller_name}\" controller." +
        "Only #{@@PmdControllers.join(", ")}"
    end
    self.pmd_controller_no = idx
  end

  def pmd_controllers
    @@PmdControllers
  end

end
