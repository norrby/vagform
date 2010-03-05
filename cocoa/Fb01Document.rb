#
# MyDocument.rb
# cocoa
#
# Created by M Norrby on 3/5/10.
# Copyright M Norrby 2010. All rights reserved.
#

framework 'macruby-midi'
#framework 'PYMIDI'

require 'midi_lex'
require 'midi_communicator'
require 'configuration'

class Fb01Document < NSDocument
  @@communicator = MidiCommunicator.new(MidiLex::Sender.new(:mac_ruby),
                                        MidiLex::Receiver.new(:mac_ruby))
  @@configuration = Configuration.new(@@communicator)
  
  # Name of nib containing document window
  def windowNibName
    'Fb01Document'
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
  end
end
