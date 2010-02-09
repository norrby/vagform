framework 'macruby-midi'
framework 'PYMIDI'

require 'midi_lex'
require 'midi_communicator'
require 'yfb01/configuration'

class Editor < NSWindowController
  @@communicator = MidiCommunicator.new(MidiLex::Sender.new(:mac_ruby),
                                        MidiLex::Receiver.new(:mac_ruby))
  @@configuration = Configuration.new(@@communicator)

  def communicator
    if not @already_done and @@communicator.devices.length > 0
      @already_done = true
      @@communicator.open(@@communicator.devices[0])
    end
    @@communicator
  end

  def configuration
    @@configuration
  end

end
