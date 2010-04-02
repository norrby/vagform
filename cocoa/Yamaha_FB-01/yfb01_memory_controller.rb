# configuration_controller.rb
# cocoa
#
# Created by M Norrby on 3/6/10.
# Copyright 2010 __MyCompanyName__. All rights reserved.

module Yfb01MemoryController

  def setValue(value, forKey:key)
    value = value.to_i if value.is_a? Float
    value = 1 if value.is_a? TrueClass
    value = 0 if value.is_a? FalseClass
#    puts "#{self.class} sets  #{key}=#{value} in class #{model.class} (#{model}) from class"
    willChangeValueForKey(key)
    will_change_affected(key)
    if respond_to? (key + "=")
      send key + "=", value 
    else
      model.send key + "=", value
    end
    did_change_affected(key)
    didChangeValueForKey(key)
  end

  def will_change_affected(origin)
    return unless respond_to? :also_affected_by_key
    (also_affected_by_key(origin) || []).each {|key| willChangeValueForKey(key)}
  end

  def did_change_affected(origin)
    return unless respond_to? :also_affected_by_key
    (also_affected_by_key(origin) || []).each {|key| didChangeValueForKey(key)}
  end

  def valueForKey(key)
#    puts "#{self.class} gets value of #{key} from class #{model.class} (#{model})"
    if respond_to? key
      send key
    else
      model.send key
    end
  end

end
