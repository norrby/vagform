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
	#puts @op1.view
	#puts @split
	@split.addSubview(@inst1.view)
	@split.addSubview(@inst2.view)
	@split.addSubview(@inst3.view)
	@split.addSubview(@inst4.view)
	@split.addSubview(@inst5.view)
	@split.addSubview(@inst6.view)
	@split.addSubview(@inst7.view)
	@split.addSubview(@inst8.view)
	#@inst1.view.setFrame(@split.bounds)
	#puts @inst1.view.bounds
	#puts @inst1.where
	
	#puts @inst1.where.setFrame(@op1.where.bounds)
    #puts "haha"
  end
end
