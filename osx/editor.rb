framework 'macruby-midi'

require 'midi-lex/lib/midi_lex'
require 'midi_communicator'

class Editor < NSWindowController
  attr_writer :midi_device_selector, :midi_channel_selector, :op1, :split

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
  
  def awakeFromNib
	puts @op1.view
	puts @split
	@split.addSubview(@op1.view)
	#@op1.view.setFrame(@op1.where.bounds)
	#.setFrame(@op1.where.bounds)
    puts "haha"
  end
end
