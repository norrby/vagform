#
# MyDocument.rb
# cocoa
#
# Created by M Norrby on 3/5/10.
# Copyright M Norrby 2010. All rights reserved.
#

framework 'macruby-midi'
framework 'PYMIDI'

require 'midi_lex'
require 'midi_communicator'
require 'configuration'

class Yfb01Document < NSDocument
  @@communicator = MidiCommunicator.new(MidiLex::Sender.new(:mac_ruby),
                                        MidiLex::Receiver.new(:mac_ruby))
  @@communicator.open(@@communicator.devices[0]) if @@communicator.devices

  def communicator
    @@communicator
  end

  def configuration
    return @configuration if @configuration
    new_conf = Configuration.new(@@communicator)
    new_conf.name = "New conf"
    @configuration = Yfb01ConfigurationController.new(new_conf)
  end

  def reset_config
    new_conf = Configuration.new(@@communicator)
    new_conf.name = "Sik-fejs"
    willChangeValueForKey("configuration")
    @configuration = Yfb01ConfigurationController.new(new_conf)
    didChangeValueForKey("configuration")
  end

  # Name of nib containing document window
  def windowNibName
    'Yfb01Document'
  end
  
  # Document data representation for saving (return NSData)
  def dataOfType(type, error:outError)
    outError.assign(NSError.errorWithDomain(NSOSStatusErrorDomain, code:-4, userInfo:nil))
    nil
  end

  # Read document from data (return non-nil on success)
  def readFromData(data, ofType:type, error:outError)
    outError.assign(NSError.errorWithDomain(NSOSStatusErrorDomain, code:-4, userInfo:nil))
    nil
  end

  # Return lowercase 'untitled', to comply with HIG
  def displayName
    fileURL ? super : super.sub(/^[[:upper:]]/) {|s| s.downcase}
  end

  def awakeFromNib
    puts "document awake"
  end
end
