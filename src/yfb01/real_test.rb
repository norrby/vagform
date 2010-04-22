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
framework 'macruby-midi'

$LOAD_PATH << File.join(File.dirname(__FILE__), '../midi-lex/lib')

require 'test/unit'
require 'voice_dump'
require 'midi_lex'
require 'midi_communicator'

class RealDump < Test::Unit::TestCase
  def test_receive
    midi = MidiCommunicator.new(MidiLex::Sender.new(:mac_ruby),
                                MidiLex::Receiver.new(:mac_ruby))
    midi.system_channel = 2
    midi.open(midi.devices[0])
    puts midi.devices
    dumper = VoiceDump.new(midi)
    dumper.from_instrument(0)
    voice = dumper.to_voice
    puts "Got: #{voice.name}"
  end
end
