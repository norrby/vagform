# -*- coding: iso-8859-1 -*-
require 'voice'
require 'model_bindings'

class FB01Voice < NSViewController
  include ModelBindings
  attr_writer :parent_view
  attr_writer :editor
  attr_writer :lfo_speed_selector, :lfo_speed_label
  attr_writer :name_field
  attr_writer :portamento_slider, :portamento_label
  attr_writer :pmd_controller_selector, :transpose_slider
  attr_writer :bender_slider, :ams_slider, :pms_slider
  attr_writer :load_lfo_checkbox, :sync_lfo_checkbox
  attr_writer :algorithm

  def invalidate(voice)
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

  def operators
    model.operators
  end

  def empty_init?
    not @voice
  end

  def new_model(new_voice)
    set_enabled(view, true) unless empty_init?
    @voice.unsubscribe(self) if @voice
    new_voice.subscribe(self, :invalidate)
    @voice = new_voice
    self.invalidate(new_voice)
  end

  def set_enabled(a_view, enabled)
    if a_view.is_a? NSControl
      a_view.setEnabled(enabled)
    else
      a_view.subviews.each {|sub| set_enabled(sub, enabled)}
    end
  end

  def model
    return @voice if @voice
    new_model(Voice.null)
    @voice
  end

  def voice_from_fb01(sender)
    @editor.reread_voice
    invalidate(model)
  end

  def awakeFromNib
    return if @parent_view.subviews.include? view
    @parent_view.addSubview(view)
    set_enabled(view, false)
  end

end
