class Voice

  @@Waveforms = ["Sawtooth", "Square", "Triangle", "Noise"]
  @@PmdControllers = {1=>"Modulation wheel", 2=>"Breath controller", 4=>"Foot controller"}

  def initialize(voice_dump = nil)
    @memory = voice_dump || Array.new(0x40, 0)
  end

  def name
    @memory[0..6].inject("") { |result, char| result << char.chr }
  end

  def name=(name)
    @memory.fill(0, 0..6)
    name.each_char.each_with_index {|ch, idx| @memory[idx] = ch.ord}
  end

  def lfo_speed
    @memory[0x08]
  end

  def raise_if(info, value, lower_bound, upper_bound)
    if value < lower_bound or value > upper_bound
      raise "#{info} must be in the interval [#{lower_bound}..#{upper_bound}]"
    end
  end

  def lfo_speed=(speed)
    raise_if "LFO speed", speed, 0, 255
    @memory[0x08] = speed
  end

  def amd
    @memory[0x09] & 0x7F
  end

  def amd=(amd)
    raise_if "AMD", amd, 0, 127
    @memory[0x09] = amd | 0x80
  end

  def sync_lfo_at_note_on?
    (@memory[0x0A] & 0x80) > 0
  end

  def sync_lfo_at_note_on=(should_sync)
    if should_sync
      @memory[0x0A] |= 0x80
    else
      @memory[0x0A] &= 0x7F
    end
  end

  def pmd
    @memory[0x0A] & 0x7F
  end

  def pmd=(pmd)
    raise_if "PMD", pmd, 0, 127
    @memory[0x0A] &= 0x80
    @memory[0x0A] |= pmd
  end

  def operator_enabled?(*operators)
    op_mask = (@memory[0x0B] >> 3) & 0x0F
    operators.flatten.each {|op| return false if op_mask & (0x01 << op) == 0}
    true
  end

  def enable_operator(*operators)
    allowed = [0, 1, 2, 3]
    ops = operators.flatten
    raise "Operator must be one of #{allowed}" if not ops.detect {|op| allowed.include?(op)}
    ops.each { |op| @memory[0x0B] |= (0x08 << op) }
  end

  def disable_operator(*operators)
    allowed = [0, 1, 2, 3]
    ops = operators.flatten
    raise "Operator must be one of #{allowed}" if not ops.detect {|op| allowed.include?(op)}
    ops.each { |op| @memory[0x0B] &= ((~(0x08 << op)) & 0xFF) }
  end

  def feedback_level
    (@memory[0x0C] & 0x38) >> 3
  end

  def feedback_level=(feedback)
    raise_if "The feedback level", feedback, 0, 7
    @memory[0x0C] |= feedback << 3
  end

  def algorithm
    @memory[0x0C] & 0x07
  end

  def algorithm=(algorithm)
    raise_if "algorithm", algorithm, 0, 7
    @memory[0x0C] &= 0xF8
    @memory[0x0C] |= algorithm
  end

  def pms
    (@memory[0x0D] & 0x70) >> 4
  end

  def pms=(pms)
    raise_if "PMS", pms, 0, 7
    @memory[0x0D] &= 0x8F
    @memory[0x0D] |= pms << 4
  end

  def ams
    @memory[0x0D] & 0x07
  end

  def ams=(feedback)
    raise_if "ams", feedback, 0, 3
    @memory[0x0D] &= 0xF8
    @memory[0x0D] |= feedback
  end

  def lfo_waveform
    wave_num = (@memory[0x0E] & 0x60) >> 5
    @@Waveforms[wave_num]
  end

  def lfo_waveform=(waveform_name)
    wave_num = @@Waveforms.index(waveform_name)
    raise "Waveform must be one of #{@@Waveforms}" if not wave_num 
    @memory[0x0E] &= 0x9F
    @memory[0x0E] |= (wave_num << 5)
  end

  def transpose
    @memory[0x0F]
  end

  def transpose=(transpose)
    raise_if "Transpose", transpose, 0, 255
    @memory[0x0F] = transpose
  end

  def poly?
    @memory[0x3A] & 0x80 > 0
  end

  def mono?
    not poly?
  end

  def poly=(is_poly)
    if (is_poly)
      @memory[0x3A] |= 0x80
    else
      @memory[0x3A] &= 0x7F
    end
  end

  def mono=(is_mono)
    poly=(not is_mono)
  end

  def portamento
    @memory[0x3A] & 0x7F
  end

  def portamento=(portamento)
    raise_if "Portamento", portamento, 0, 127
    @memory[0x3A] &= 0x80
    @memory[0x3A] |= portamento
  end

  def pmd_controller
    controller_num = (@memory[0x3B] & 0x70) >> 4
    @@PmdControllers[controller_num]
  end

  def pmd_controller=(controller_name)
    if not @@PmdControllers.has_value?(controller_name)
      raise "There is no \"#{controller_name}\" controller. Only #{@@PmdControllers.values}"
    end
    controller_num = @@PmdControllers.key(controller_name)
    @memory[0x3B] &= 0x8F
    @memory[0x3B] |= (controller_num << 4)
  end

  def pitchbend_range
    @memory[0x3B] & 0x0F
  end

  def pitchbend_range=(range)
    raise_if "Pitchbend range", range, 0, 15
    @memory[0x3B] &= 0xF0
    @memory[0x3B] |= range
  end

end
