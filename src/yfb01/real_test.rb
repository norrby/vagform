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
