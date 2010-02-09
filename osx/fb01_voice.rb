class FB01Voice < NSViewController
  attr_writer :parent_view
  attr_writer :editor
  attr_writer :lfo_speed_selector
  attr_writer :name_field

  def voice
    @editor.voice
  end

  def voice_from_fb01(sender)
    @editor.reread_voice
    invalidate
  end

  def awakeFromNib
    @parent_view.addSubview(view)
  end

  def valueForKey(key)
    #voice.instrument_no = 1
    voice.send key
  end

  def invalidate
    @lfo_speed_selector.setFloatValue(voice.lfo_speed)
    @name_field.setStringValue(voice.name)
  end

  def setValue(value, forKey:key)
    value = value.to_i if value.class == Float
    value = 1 if value.class == TrueClass
    value = 0 if value.class == FalseClass
    voice.send key + "=", value
    invalidate
  end

end
