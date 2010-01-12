# -*- coding: iso-8859-1 -*-
require 'test/unit'
require 'voice_dump'

class FakeCommunicator
  attr_reader :sent, :system_channel
  attr_accessor :reply

  def initialize(channel)
    @system_channel = channel
  end

  def sysex(dump)
    @sent = dump
  end

  def capture(args, &block)
    @reply.each {|byte| yield [byte]}
  end
end

class VoiceDumpTest < Test::Unit::TestCase
  def setup
    @system_channel = 1
    @communicator = FakeCommunicator.new(@system_channel)
    @dumper = VoiceDump.new(@communicator)
  end

  def test_dump_instrument_data_0
    @dumper.dump_instrument(0)
    assert_equal [0x43, 0x75, 0x00, 0x08, 0x00, 0x00], @communicator.sent[0..5]
  end

  def test_from_instrument_0
   arr = (1..20).to_a
   @communicator.reply = [0xF0, 0x43, 0x75, 0x00, 0x08, 0x00, 0x00]
   @communicator.reply.concat [0x01, 0x03] #(0x40 * 2) + 3
   @communicator.reply.concat [0x07, 0x04] * 0x80
   @communicator.reply.concat [0xEE] # faulty checksum
   @communicator.reply.concat [0xF7]
   @dumper.from_instrument(0)
   assert_equal [0x43, 0x75, 0x00, 0x28, 0x00, 0x00], @communicator.sent[0..5]
  end
end
