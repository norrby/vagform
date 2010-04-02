require 'Yamaha_FB-01/yfb01_memory_controller'

class Yfb01InstrumentLargeViewController < NSViewController
  attr_writer :parent_view
  attr_accessor :instruments

  def awakeFromNib
    return unless @parent_view
    @parent_view.addSubview(view)
  end
end
