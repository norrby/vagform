framework 'macruby-midi'

require 'midi-lex/lib/midi_lex'
require 'midi_communicator'

class Editor < NSWindowController
  attr_writer :midi_device_selector, :midi_channel_selector, :op1, :split
  attr_writer :inst1, :inst2, :inst3, :inst4, :inst5, :inst6, :inst7, :inst8

  @@midi = MidiCommunicator.new(MidiLex::Sender.new(:mac_ruby),
                                MidiLex::Receiver.new(:mac_ruby))
  def device_selected(sender)
    @@midi.open(sender.titleOfSelectedItem)
  end

  def midi_devices
    available_devices = @@midi.devices
    @@midi.open(available_devices[0]) if available_devices.length > 0
    available_devices
  end

  def midi_channels
    @@midi.channels
  end

  def midi_channel_selected(sender)
    @@midi.system_channel = sender.titleOfSelectedItem.to_i
  end
  
  def awakeFromNib
    @instruments = [@inst1, @inst2, @inst3, @inst4, @inst5, @inst6, @inst7, @inst8]
    pos = 182.0 * @instruments.length
    @split.setFrameSize(NSSize.new(991.0, 182.0 * @instruments.length))
    @instruments.each_with_index do |instr, index|
      instr.communicator = @@midi
      instr.instrument_no = index + 1
      pos -= 182.0 #could not be calculated on my 32 bit machine. Crash on f32UNREACHABLE
      view = instr.view
      @split.addSubview(view)
      view.setFrameOrigin(NSPoint.new(0.0, pos))
    end
  end
end
