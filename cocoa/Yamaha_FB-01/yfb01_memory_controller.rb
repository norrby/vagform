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
    if respond_to? key
      send key
    else
      model.send key
    end
  end

end
