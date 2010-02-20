# fb01_instruments.rb
# FB-01_Editor
#
# Created by M Norrby on 2/7/10.
# Copyright 2010 __MyCompanyName__. All rights reserved.

class FB01Instruments < NSViewController
  attr_writer :i1, :i2, :i3, :i4, :i5, :i6, :i7, :i8
  attr_writer :editor, :parent_view, :voice_editor

  def awakeFromNib
    @parent_view.addSubview(view) unless @parent_view.subviews.include? view
  end

  def selected_instrument
    return Instrument.null if not controllers
    instr = controllers.detect {|instr| instr.chosen }
    return instr.instrument if instr
    Instrument.null
  end

  def any_instrument_selected?
    controllers.detect {|instr| instr.chosen}
  end

  def assure_one_instrument_selected
    @i1.select_me unless any_instrument_selected?
  end

  def selected_instrument_is(controller)
    controllers.each {|instr| instr.deselect_me unless instr.equal? controller}
    @voice_editor.new_instrument_selected
  end

  def instruments
    @editor.configuration.instruments
  end

  def invalidate
    controllers.each {|controller| controller.invalidate}
  end

  def total_notes
    controllers.inject(0) {|sum, c| sum += c.valueForKey(:notes)}
  end

  def controllers
    return @instrument_controllers if @instrument_controllers
    if (@i1 and @i2 and @i3 and @i4 and @i5 and @i6 and @i7 and @i8)
      return @instrument_controllers = [@i1, @i2, @i3, @i4, @i5, @i6, @i7, @i8]
    end
    nil
  end

  def instrument(controller)
    return instruments[controllers.index(controller)]
  end

end
