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
require 'Yamaha_FB-01/yfb01_voice_controller'

class Yfb01InstrumentController
  include Yfb01MemoryController
  attr_accessor :name, :voice_controller
  @@Affected = {
    "lower_key_limit" => ["lower_key_limit_name",
                          "upper_key_limit",
                          "upper_key_limit_name"],
    "lower_key_limit_name" => ["lower_key_limit",
                               "upper_key_limit",
                               "upper_key_limit_name"],
    "upper_key_limit" => ["upper_key_limit_name",
                          "lower_key_limit",
                          "lower_key_limit_name"],
    "upper_key_limit_name" => ["upper_key_limit",
                               "lower_key_limit",
                               "lower_key_limit_name"],
  }

  def initialize(model, no)
    @model = model
    @name = "Instrument #{no}"
    @voice_controller = Yfb01VoiceController.new(model.voice)
  end

  def also_affected_by_key(key)
    @@Affected[key]
  end

  def model
    return @model
  end
end
