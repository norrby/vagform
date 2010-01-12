framework 'macruby-midi'

require 'midi-lex/lib/midi_lex'
require 'midi_communicator'

class Editor < NSWindowController
  attr_writer :midi_device_selector, :midi_channel_selector

  @@midi = MidiCommunicator.new(MidiLex::Sender.new(:mac_ruby),
                                MidiLex::Receiver.new(:mac_ruby))
  def device_selected(sender)
    @@midi.open(sender.titleOfSelectedItem)
  end

  def midi_devices
    @midi_device_selector.sizeToFit
    available_devices = @@midi.devices
    @@midi.open(available_devices) if available_devices.length > 0
    available_devices
  end

  def midi_channels
    @midi_channel_selector.sizeToFit
    @@midi.channels
  end

  def midi_channel_selected(sender)
    @@midi.system_channel = sender.titleOfSelectedItem
  end

end
