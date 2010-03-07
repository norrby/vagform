# configuration_controller.rb
# cocoa
#
# Created by M Norrby on 3/6/10.
# Copyright 2010 __MyCompanyName__. All rights reserved.

module Yfb01MemoryController

  def setValue(value, forKey:key)
    puts "setting value of #{key} in class #{model.class} (#{model})"
    willChangeValueForKey(key)
    model.send key + "=", value
    didChangeValueForKey(key)
  end

  def valueForKey(key)
    puts "value of #{key} from class #{model.class} (#{model})"
    model.send key
  end

end
