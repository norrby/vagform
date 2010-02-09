# fb01_instruments.rb
# FB-01_Editor
#
# Created by M Norrby on 2/7/10.
# Copyright 2010 __MyCompanyName__. All rights reserved.

class FB01Instruments < NSViewController
  attr_writer :i1, :i2, :i3, :i4, :i5, :i6, :i7, :i8
  attr_writer :editor, :parent_view, :voice_editor
  attr_reader :selected_instrument

  def awakeFromNib
    @parent_view.addSubview(view)
  end

  def selected_instrument
    return @selected_instrument if @selected_instrument
    @selected_instrument = instruments[0]
  end

  def instruments
    @editor.configuration.instruments
  end

  def invalidate
    controllers.each {|controller| controller.invalidate}
  end

  def chose_instrument(sender)
    @selected_instrument = instrument(sender)
    @voice_editor.invalidate
    controllers.each {|controller| controller.deselect_instrument if controller != sender}
  end

  def controllers
    return @instrument_controllers if @instrument_controllers
    @instrument_controllers = [@i1, @i2, @i3, @i4, @i5, @i6, @i7, @i8]
  end

  def instrument(controller)
    return instruments[controllers.index(controller)]
  end

end
