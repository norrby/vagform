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

  def invalidate
    puts "invalidating"
    puts "bank:  #{instrument.voice_bank_no}"
    puts "voice: #{instrument.voice_no}"
    @bank_selector.selectItemAtIndex(instrument.voice_bank_no)
    @voice_selector.selectItemAtIndex(instrument.voice_no)
    @upper_key_limit_slider.setFloatValue(instrument.upper_key_limit)
    @lower_key_limit_slider.setFloatValue(instrument.lower_key_limit)
    @upper_key_limit_label.setStringValue(instrument.upper_key_limit_name)
    @lower_key_limit_label.setStringValue(instrument.lower_key_limit_name)
  end

  def instrument
    @editor.instrument
  end

  def awakeFromNib
    @parent_view.addSubview(view)
  end

  def valueForKey(key)
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
    puts "setValue #{key}=#{value}"
    value = value.to_i if value.class == Float
    value = 1 if value.class == TrueClass
    value = 0 if value.class == FalseClass
    instrument.send key + "=", value
    invalidate
  end

end
