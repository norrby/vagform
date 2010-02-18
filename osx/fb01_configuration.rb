require 'model_bindings'

class FB01Configuration < NSViewController
  include ModelBindings
  attr_writer :editor, :view_parent
  attr_writer :lfo_waveform_selector, :name_field, :kc_responder_selector
  attr_writer :amd_dial, :amd_slider, :pmd_dial, :pmd_slider, :lfo_speed_slider
  attr_writer :progress, :instruments

  def midi
    @editor.communicator
  end

  def model
    @editor.configuration
  end

  def bulk_fetch(sender)
    @progress.startAnimation(self)
    @progress.setUsesThreadedAnimation(true)
    @progress.setMaxValue 10.0
    @progress.setMinValue 0.0
    @progress.setDoubleValue 0.0
    model.bulk_fetch do |max, min, current|
      @progress.setMaxValue max
      @progress.setMinValue min
      @progress.setDoubleValue current
      
    end
    @progress.stopAnimation(self)
    @instruments.invalidate
  end

  def kc_respond(sender)
    even = sender.isSelectedForSegment(0) ? 1 : 0
    odd = sender.isSelectedForSegment(1) ? 2 : 0
    kc = (odd + even)
    unless kc == 0
      kc = kc % 3
      model.kc_reception_mode = kc
    end
  end

  def kc_even
    kc = model.kc_reception_mode
    kc == 0 || (kc & 0x01 > 0)
  end

  def kc_odd
    kc = model.kc_reception_mode
    kc == 0 || (kc & 0x02 > 0)
  end

  def invalidate(config)
    @name_field.setStringValue(config.name)
    @lfo_waveform_selector.selectCellAtRow(config.lfo_waveform_no, column:0)
    @kc_responder_selector.setSelected(self.kc_even, forSegment:0)
    @kc_responder_selector.setSelected(self.kc_odd, forSegment:1)
    @amd_slider.setFloatValue(config.amd)
    @pmd_slider.setFloatValue(config.pmd)
    @amd_dial.setFloatValue(config.amd)
    @pmd_dial.setFloatValue(config.pmd)
    @lfo_speed_slider.setFloatValue(config.lfo_speed)
  end

  def awakeFromNib
    return if @view_parent.subviews.include? view
    @view_parent.addSubview(view)
    model.subscribe(self, :invalidate)
  end
end
