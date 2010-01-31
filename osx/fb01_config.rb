#
# MyDocument.rb
# FB-01_Editor
#
# Created by M Norrby on 1/31/10.
# Copyright __MyCompanyName__ 2010. All rights reserved.
#

class Fb01Config < NSDocument
  
  # Name of nib containing document window
  def windowNibName
    'Fb01Config'
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
  
end
