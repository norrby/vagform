# yfb01_instrument_bay.rb
# cocoa
#
# Created by M Norrby on 3/13/10.
# Copyright 2010 __MyCompanyName__. All rights reserved.

class Yfb01InstrumentBay < NSViewController
  attr_writer :parent_view
  attr_accessor :document

  def awakeFromNib
    puts "instrument bay awoke"
    @parent_view.addSubview(view) if view
  end
end
