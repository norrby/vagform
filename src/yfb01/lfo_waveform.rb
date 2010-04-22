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
# Provides LFO waveform support.
# Needs a :lfo_waveform_no to work
module LfoWaveform
  @@LfoWaveforms = ["Sawtooth", "Square", "Triangle", "Sample and Hold"]

  def lfo_waveforms
    return @@LfoWaveforms
  end

  def lfo_waveform=(waveform)
    index_of_provided_wf = @@LfoWaveforms.index(waveform)
    raise ArgumentError, "unknown LFO waveform " + waveform if not index_of_provided_wf
    self.lfo_waveform_no = index_of_provided_wf
  end

  def lfo_waveform
    @@LfoWaveforms[lfo_waveform_no]
  end
end
