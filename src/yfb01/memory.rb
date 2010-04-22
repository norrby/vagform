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
module Memory

  def self.define(min, max, pos, mask)
    {:min => min, :max => max, :pos => pos, :mask => mask}
  end

  def shift_steps(mask)
    steps = 0
    while ((mask >> steps) & 0x01) == 0
      steps += 1
    end
    return steps
  end

  def store(pos, mask, value)
    raise "cannot store non integer #{value} at #{pos}" unless value.is_a? Integer
    shift = shift_steps(mask)
    before_store_hook if respond_to? :before_store_hook
    @data[pos] = (@data[pos] & ~mask) | (value << shift)
    store_hook if respond_to? :store_hook
  end

  def set(pos, mask, value)
    store(pos, mask, value)
    send_to_fb01(pos, @data[pos]) if @comm
  end

  def self.[](*args)
    self.define(*args)
  end

  def mask(symbol, shift = 0)
    @parameters[symbol][:mask] >> shift
  end

  def pos(symbol)
    @parameters[symbol][:pos]
  end

  def fetch(parameter)
    mask = mask(parameter)
    (@data[pos(parameter)] & mask) >> shift_steps(mask)
  end

  def self.accessors(defs)
    defs.each_key do |key|

      define_method key do
        fetch(key)
      end
      
      define_method "#{key}=".to_sym do |value|
        lower_bound = @parameters[key][:min] 
        upper_bound = @parameters[key][:max] 
        if value < lower_bound or value > upper_bound
          raise "#{key} must be in the interval [#{lower_bound}..#{upper_bound}]"
        end
        set(pos(key), mask(key), value)
      end
      
      define_method "min_#{key}".to_sym do
        @parameters[key][:min]
      end
      
      define_method "max_#{key}".to_sym do
        @parameters[key][:max]
      end

      define_method "#{key}_to_s".to_sym do
        (send key).to_s
      end
    end
  end
  
end
