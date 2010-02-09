# fb01_instrument_voice.rb
# FB-01_Editor
#
# Created by M Norrby on 2/7/10.
# Copyright 2010 __MyCompanyName__. All rights reserved.

class FB01InstrumentVoice < NSViewController
  attr_writer :parent_view, :instruments
  attr_accessor :instrument
  attr_writer :instrument_controller, :voice_controller

  def new_edit(instrument)
    @instrument = instrument
    invalidate
  end

  def instrument
    @instruments.selected_instrument
  end

  def voice
    instrument.voice
  end

  def reread_voice
    instrument.read_voice_data_from_fb01
  end

  def invalidate
    @instrument_controller.invalidate
    @voice_controller.invalidate
  end

  def awakeFromNib
    @parent_view.addSubview(view)
  end
end
