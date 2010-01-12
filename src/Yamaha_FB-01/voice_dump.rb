require 'voice'

class VoiceDump

  def initialize(communicator)
    @communicator = communicator
  end

  def [](idx)
    @backing_store[idx]
  end

  def dump_instrument(instrument_no)
    channel = @communicator.system_channel
    @communicator.sysex([0x43, 0x75, channel - 1, 0x08 + instrument_no, 0x00, 0x00])
  end

  def from_instrument(instrument_no)
    channel = @communicator.system_channel
    @communicator.sysex([0x43, 0x75, 0x00 + channel - 1, 0x28 + instrument_no, 0x00, 0x00])
    dump = []
    catch :done do
      @communicator.capture(:format => :Raw) do |data|
        dump.concat(data)
        next if dump.length < 9
        stated_packet_size = ((dump[0x07] & 0x01) << 7) + dump[0x08]
        printf "size = 0x%0X\n", stated_packet_size if dump.length < 20
        throw :done if dump.length >= (stated_packet_size + 11)
      end
    end
    puts "received #{dump.size} ending with #{dump[-1]}"
    @backing_store = Array.new((dump.length - 11)/2)
    @backing_store.each_index {|idx| @backing_store[idx] = dump[idx*2+9] + (dump[idx*2+10] << 4) }
    #@backing_store = (0..(((dump.length - 11)/2) - 1)).inject([]) {|res, idx| res << dump[idx * 2 + 9] + (dump[idx * 2 + 10] << 4)}
    puts @backing_store.length
    puts @backing_store
  end

  def to_voice
    return Voice.new(self)
  end

end
