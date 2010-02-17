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
    shift = shift_steps(mask)
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
    (@data[pos(parameter)] & mask(parameter)) >> shift_steps(mask)
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
        puts "asking about string"
        (send key).to_s
        "banjo"
      end
    end
  end
  
end
