# -*- coding: iso-8859-1 -*-
class LfoWaveform < NSArrayController
  attr_writer :configuration_controller

  def config
    @configuration_controller.config
  end  

  def setValue(value, forKey:key)
    puts "sending #{value} for #{key}"
    config.lfo_waveform = value
    setSelectedObjects([config.lfo_waveform])
  end

  def awakeFromNib
    addObjects(config.lfo_waveforms)
  end
end

class FB01Configuration < NSViewController
  attr_writer :editor, :view_parent
  attr_writer :lfo_waveform_selector, :name_field, :kc_responder_selector

  def midi
    @editor.communicator
  end

  def config
    @editor.configuration
  end

  def kc_respond(sender)
    even = sender.isSelectedForSegment(0) ? 1 : 0
    odd = sender.isSelectedForSegment(1) ? 2 : 0
    kc = (odd + even)
    puts "even: #{even}, odd: #{odd}"
    if kc == 0
      invalidate 
    else
      kc = kc % 3
      config.kc_reception_mode = kc
      invalidate
    end
  end

  def kc_even
    kc = config.kc_reception_mode
    kc == 0 || (kc & 0x01 > 0)
  end

  def kc_odd
    kc = config.kc_reception_mode
    kc == 0 || (kc & 0x02 > 0)
  end

  def invalidate
    @name_field.setStringValue(config.name)
    @lfo_waveform_selector.selectCellAtRow(config.lfo_waveform_internal, column:0)
    puts "even: #{self.kc_even}, odd: #{self.kc_odd} (invalidate, kc=#{config.kc_reception_mode})"
    @kc_responder_selector.setSelected(self.kc_even, forSegment:0)
    @kc_responder_selector.setSelected(self.kc_odd, forSegment:1)
  end

  def valueForKey(key)
    config.send key
  end

  def setValue(value, forKey:key)
    config.send key + "=", value
    invalidate
  end

  def awakeFromNib
    @view_parent.addSubview(view)
  rescue => e
    puts "Error " + e.message
  end
end
