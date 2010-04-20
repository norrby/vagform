# yfb01_configuration_view_controller.rb
# cocoa
#
# Created by M Norrby on 3/7/10.
# Copyright 2010 __MyCompanyName__. All rights reserved.

class Yfb01ConfigurationViewController < NSViewController
  attr_writer :parent_view
  attr_accessor :document

  def set_odd(sender)
    @document.configuration.setValue(sender.intValue, forKey:"kc_reception_odd")
  end

  def set_even(sender)
    @document.configuration.setValue(sender.intValue, forKey:"kc_reception_even")
  end

  def awakeFromNib
    @parent_view.addSubview(view) if view
  end

end
