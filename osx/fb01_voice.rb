# -*- coding: iso-8859-1 -*-
require 'voice'

class FB01Voice < NSViewController
  attr_writer :parent_view
  attr_writer :editor
  attr_writer :lfo_speed_selector, :lfo_speed_label
  attr_writer :name_field
  attr_writer :portamento_slider, :portamento_label
  attr_writer :pmd_controller_selector, :transpose_slider
  attr_writer :bender_slider, :ams_slider, :pms_slider
  attr_writer :load_lfo_checkbox, :sync_lfo_checkbox
  attr_writer :algorithm

  def voice
    return Voice.new(nil) unless @editor
    @editor.voice
  end

  def operators
    voice.operators
  end

  def voice_from_fb01(sender)
    @editor.reread_voice
    invalidate
  end

  def awakeFromNib
    @parent_view.addSubview(view) if not @parent_view.subviews.include? view
  end

  def notify(voice)
    invalidate
  end

  def valueForKey(key)
    voice.send key
  end

  def invalidate
    @lfo_speed_selector.setFloatValue(voice.lfo_speed)
    @lfo_speed_label.setFloatValue(voice.lfo_speed)
    @name_field.setStringValue(voice.name)
    @portamento_slider.setFloatValue(voice.portamento_time)
    @portamento_label.setFloatValue(voice.portamento_time)
    @pmd_controller_selector.selectItemAtIndex(voice.pmd_controller_no)
    @bender_slider.setFloatValue(voice.pitchbender_range)
    @ams_slider.setFloatValue(voice.ams)
    @pms_slider.setFloatValue(voice.pms)
    @sync_lfo_checkbox.setState(voice.sync_lfo)
    @load_lfo_checkbox.setState(voice.load_lfo)
    @transpose_slider.setFloatValue(voice.transpose)
    @algorithm.selectTabViewItemAtIndex(voice.algorithm)
  end

  def setValue(value, forKey:key)
    value = value.to_i if value.class == Float
    value = 1 if value.class == TrueClass
    value = 0 if value.class == FalseClass
    voice.send key + "=", value
    invalidate
  end

end
