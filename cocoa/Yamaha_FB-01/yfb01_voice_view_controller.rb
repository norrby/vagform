# yfb01_voice_view_controller.rb
# cocoa
#
# Created by M Norrby on 4/2/10.
# Copyright 2010 __MyCompanyName__. All rights reserved.

class Yfb01VoiceViewController < NSViewController
  attr_writer :parent_view
  attr_accessor :instruments

  def awakeFromNib
    return unless @parent_view
    @parent_view.addSubview view
  end
end

