class Yfb01AlgorithmViewController < NSViewController
  attr_writer :parent_view
  attr_accessor :voice_controller

  def awakeFromNib
    return unless @parent_view
    @parent_view.addSubview(view)
  end

  def press(sender)
    puts sender.ar
  end

end
