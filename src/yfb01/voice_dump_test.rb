#  .
# VAGFORM, a MIDI Synth Editor
# Copyright (C) 2010  M Norrby
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
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
