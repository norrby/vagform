# yfb01_voice_view_controller.rb
# cocoa
class Yfb01VoiceViewController < NSViewController
  attr_writer :parent_view
  attr_writer :op0_editor
  attr_writer :op1_editor
  attr_writer :op2_editor
  attr_writer :op3_editor
  attr_accessor :instruments

  def edit_op0(sender)
    @op0_editor.showWindow(sender)
  end

  def edit_op1(sender)
    @op1_editor.showWindow(sender)
  end

  def edit_op2(sender)
    @op2_editor.showWindow(sender)
  end

  def edit_op3(sender)
    @op3_editor.showWindow(sender)
  end

  def awakeFromNib
    return unless @parent_view
    @parent_view.addSubview view
  end
end
