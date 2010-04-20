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
require 'Yamaha_FB-01/yfb01_configuration_controller'

dir_path = NSBundle.mainBundle.resourcePath.fileSystemRepresentation
synth_path = File.join(dir_path, "Yamaha_FB-01")
Dir.glob(File.join(synth_path, '*.{rb,rbo}')).map { |x| File.basename(x, File.extname(x)) }.uniq.each do |path|
  require(File.join(synth_path, path))
end

class Yfb01Document < NSDocument
  @@communicator = MidiCommunicator.new(MidiLex::Sender.new(:mac_ruby),
                                        MidiLex::Receiver.new(:mac_ruby))
  @@communicator.open(@@communicator.devices[0]) if @@communicator.devices
  attr_accessor :configuration

  def communicator
    @@communicator
  end

  def reset_config
    new_conf = Configuration.new(@@communicator)
    new_conf.bulk_fetch
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

  def initWithType(name, error:error)
    super if @configuration
    midi = if @@communicator.devices.size == 0
             nil
           else
             @@communicator
           end

    new_conf = Configuration.new(midi)
    new_conf.name = "Empty conf"
    @configuration = Yfb01ConfigurationController.new(new_conf)
    super
  end

  def awakeFromNib
  end
end
