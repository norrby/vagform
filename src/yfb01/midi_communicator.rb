require 'timeout'

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

  def receive_raw_dump(expected)
    dump = []
    laps  = 0
    Timeout::timeout(3) do
      catch :done do
        capture(:format => :Raw) do |data|
          dump.concat(data)
          next if dump.length < 9
          stated_packet_size = ((dump[0x07] & 0x01) << 7) + dump[0x08]
          throw :done if dump.length >=(stated_packet_size + 11) or dump.include? 0xF7
        end #capture
      end #catch
    end #timeout
    raise "wrong header" if dump[0..expected.length - 1] != expected
    checksum = dump[-2]
    sum = dump[0x09..-3].inject(0) {|sum, byte| sum + byte}
    raise "wrong checksum" if (sum + checksum) & 0x7F != 0
    return dump[0x09..-3]
  rescue =>e
    puts "fyy! #{e.message}"
    #ignore silently, caused by timeout slaying the midi_lex thread
    return nil
  end

  def receive_dump(request, expected_header)
    7.times do
      sysex(request)
      dump = receive_raw_dump(expected_header)
      return dump if dump
      sleep 2
    end
    return nil
  end

  def receive_interleaved_dump(request, expected_header)
    stuffed_data = receive_dump(request, expected_header)
    return nil unless stuffed_data
    low = Array.new(stuffed_data.length / 2) {|i| stuffed_data[2 * i]}
    high = Array.new(stuffed_data.length / 2) {|i| stuffed_data[2 * i + 1]}
    data = low.each_index.collect {|i| low[i] + (high[i] << 4)}
    return data
  end

end
