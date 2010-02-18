require 'model_bindings'
require 'model_enabled'

class FB01InstrumentLarge < NSViewController
  include ModelBindings
  include ModelEnabled
  attr_writer :parent_view, :editor
  attr_writer :bank_selector, :voice_selector
  attr_writer :upper_key_limit_slider, :lower_key_limit_slider
  attr_writer :upper_key_limit_label, :lower_key_limit_label
  attr_writer :pan_slider, :transpose_slider, :bender_slider
  attr_writer :detune_slider, :detune_label
  attr_writer :portamento_slider, :portamento_label
  attr_writer :pmd_controller_selector
  attr_writer :lfo_checkbox, :mono_checkbox
  attr_writer :refetch_checkbox

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

  def null_model
    Instrument.null
  end

  def set_enabled(a_view, enabled)
    if a_view.is_a? NSControl
      a_view.setEnabled(enabled) 
    else
      a_view.subviews.each {|sub| set_enabled(sub, enabled)}
    end
  end

  def awakeFromNib
    return if @parent_view.subviews.include? view
    @parent_view.addSubview(view)
    set_enabled(view, false)
  end

  def set_voice_bank(sender)
    model.voice_bank_no = sender.indexOfSelectedItem
    @editor.reread_voice if @refetch_checkbox.intValue == 1
  end

  def set_voice(sender)
    model.voice_no = sender.indexOfSelectedItem
    @editor.reread_voice if @refetch_checkbox.intValue == 1
  end

end
