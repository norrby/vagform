class Yfb01AlgorithmViewController < NSViewController
  attr_writer :parent_view
  attr_accessor :voice_controller
  attr_accessor :voice_view_controller

  def awakeFromNib
    return unless @parent_view
    @parent_view.addSubview(view)
  end

  def edit_op0(sender)
    @voice_view_controller.edit_op0(sender)
  end

  def edit_op1(sender)
    @voice_view_controller.edit_op1(sender)
  end

  def edit_op2(sender)
    @voice_view_controller.edit_op2(sender)
  end

  def edit_op3(sender)
    @voice_view_controller.edit_op3(sender)
  end

  def press(sender)
  end

end
