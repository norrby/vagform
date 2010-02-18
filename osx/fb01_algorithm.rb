# fb01_algorithm.rb
# FB-01_Editor
#
# Created by M Norrby on 2/12/10.
# Copyright 2010 __MyCompanyName__. All rights reserved.

class FB01Algorithm < NSViewController
  attr_writer :op1, :op2, :op3, :op4
  attr_writer :tab
  attr_writer :voice_controller

  def operators
    @voice_controller.operators
  end

  def operator_controllers
    return @operator_controllers if @operator_controllers
    if (@op1 and @op2 and @op3 and @op4)
      return @operator_controllers = [@op1, @op2, @op3, @op4]
    end
    nil
  end

  def operator(for_controller)
    return operators[operator_controllers.index(for_controller)]
  end

  def awakeFromNib
    @tab.setView(view)
  end
end
