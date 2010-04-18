class Yfb01OperatorWindowController < NSWindowController
  attr_accessor :operator_controller

  def init
    super.initWithWindowNibName("Yfb01Operator")
    super
  end

  def windowDidLoad
    puts "operator editor did load"
  end

  def awakeFromNib
    puts "Window awake"
  end
end
