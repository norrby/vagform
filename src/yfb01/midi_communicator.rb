class MidiCommunicator
  attr_reader :channels
  attr_accessor :system_channel

  def initialize(sender, receiver)
    @channels = (1..16).to_a
    @sender = sender
    @receiver = receiver
    @system_channel = 2
  end

  def devices
    @sender.ports
  end

  def open(device)
    @sender.open_port(device)
    @receiver.open_port(device)
  end

  def sysex(dump)
    @sender.sysex(dump)
  end

  def capture(args, &block)
    @receiver.capture(args, &block)
  end

end
