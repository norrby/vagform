# fb01_instrument_large.rb
# FB-01_Editor
#
# Created by M Norrby on 2/7/10.
# Copyright 2010 __MyCompanyName__. All rights reserved.

class FB01InstrumentLarge < NSViewController
  attr_writer :parent_view, :editor
  attr_writer :bank_selector, :voice_selector
  attr_writer :upper_key_limit_slider, :lower_key_limit_slider
  attr_writer :upper_key_limit_label, :lower_key_limit_label
  attr_writer :pan_slider, :transpose_slider, :bender_slider
  attr_writer :detune_slider, :detune_label
  attr_writer :portamento_slider, :portamento_label
  attr_writer :pmd_controller_selector
  attr_writer :lfo_checkbox, :mono_checkbox

  def invalidate(current)
    @bank_selector.selectItemAtIndex(current.voice_bank_no)
    @voice_selector.selectItemAtIndex(current.voice_no)
    @upper_key_limit_slider.setFloatValue(current.upper_key_limit)
    @lower_key_limit_slider.setFloatValue(current.lower_key_limit)
    @upper_key_limit_label.setStringValue(current.upper_key_limit_name)
    @lower_key_limit_label.setStringValue(current.lower_key_limit_name)
    @detune_slider.setFloatValue(current.detune)
    @detune_label.setFloatValue(current.detune)
    @portamento_slider.setFloatValue(current.portamento_time)
    @portamento_label.setFloatValue(current.portamento_time)
    @pmd_controller_selector.selectItemAtIndex(current.pmd_controller_no)
    @transpose_slider.setFloatValue(current.octave_transpose)
    @pan_slider.setFloatValue(current.pan)
    @bender_slider.setFloatValue(current.pitchbender_range)
    @lfo_checkbox.setState(current.lfo_enable)
    @mono_checkbox.setState(current.mono)
  end

  def new_instrument(new_instr)
    @instrument.unsubscribe(self) if @instrument
    new_instr.subscribe(self, :invalidate)
    @instrument = new_instr
    self.invalidate(new_instr)
    return @instrument
  end

  def instrument
    return @instrument if @instrument
    new_instrument(Instrument.null)
  end

  def awakeFromNib
    puts "instrument editor large"
    @parent_view.addSubview(view)
  end

  def valueForKey(key)
#    puts "value fr key in instrument_large. instrument=#{instrument}"
    return send key if respond_to? key
    instrument.send key
  end

  def voice_banks
    (instrument.min_voice_bank_no..instrument.max_voice_bank_no).to_a.collect do |b|
      "Bank #{b + 1}"
    end
  end

  def set_voice_bank(sender)
    instrument.voice_bank_no = sender.indexOfSelectedItem
  end

  def voices
    (instrument.min_voice_no..instrument.max_voice_no).to_a.collect do |v|
      "Voice #{v + 1}"
    end
  end

  def set_voice_no(sender)
    instrument.voice_no = sender.indexOfSelectedItem
  end

  def setValue(value, forKey:key)
    value = value.to_i if value.class == Float
    value = 1 if value.class == TrueClass
    value = 0 if value.class == FalseClass
    instrument.send key + "=", value
  end

end
