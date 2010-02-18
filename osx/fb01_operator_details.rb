require 'model_bindings'
require 'model_enabled'

class FB01OperatorDetails < NSWindowController
  include ModelBindings
#  include ModelEnabled
  attr_writer :am_carrier_checkbox
  attr_writer :key_level_scaling_depth_slider
  attr_writer :key_level_scaling_type_slider
  attr_writer :attack_rate_sensitivity_slider
  attr_writer :output_level_sensitivity_slider
  attr_writer :frequency_slider, :detune_slider, :fine_detune_slider
  attr_writer :tl_slider

  def invalidate(op)
    @am_carrier_checkbox.setIntValue(op.carrier)
    @key_level_scaling_depth_slider.setFloatValue(op.level_scaling_depth)
    @key_level_scaling_type_slider.setFloatValue(op.level_scaling_type)
    @attack_rate_sensitivity_slider.setFloatValue(op.ar_velocity_sensitivity)
    @output_level_sensitivity_slider.setFloatValue(op.tl_velocity_sensitivity)
    @frequency_slider.setFloatValue(op.frequency_multiplier)
    @detune_slider.setFloatValue(op.dt2)
    @fine_detune_slider.setFloatValue(op.dt1)
    @tl_slider.setFloatValue(op.total_level)
  end

  def model
    @op
  end

  def new_model(op)
    @op = op
  end

  def awakeFromNib
    puts "awake"
  end

end
