module PmdControllers
  @@PmdControllers = ["Not assigned", "After touch",
                      "Modulation wheel", "Breath controller", "Foot controller"]

  def pmd_controller
    @@PmdControllers[pmd_controller_no]
  end

  def pmd_controller=(controller_name)
    if not idx = @@PmdControllers.index(controller_name)
      raise "There is no \"#{controller_name}\" controller." +
        "Only #{@@PmdControllers.join(", ")}"
    end
    self.pmd_controller_no = idx
  end

  def pmd_controllers
    @@PmdControllers
  end

end
