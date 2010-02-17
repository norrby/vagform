# fb01_instrument_voice.rb
# FB-01_Editor
#
# Created by M Norrby on 2/7/10.
# Copyright 2010 __MyCompanyName__. All rights reserved.

class FB01InstrumentVoice < NSViewController
  attr_writer :parent_view, :instruments
  attr_writer :instrument_controller, :voice_controller

  def instrument
    @instruments.selected_instrument
  end

  def voice
    instrument.voice
  rescue
    Voice.null
  end

  def reread_voice
    instrument.read_voice_data_from_fb01
  end

  def new_instrument_selected
    invalidate
  end

  def invalidate
    @instrument_controller.new_instrument(instrument)
   # @voice_controller.new_voice(voice)
  end

  def awakeFromNib
    @parent_view.addSubview(view)
  end
end
