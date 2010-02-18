module ModelEnabled
  def empty_init?
    not @model
  end

  def new_model(new_model)
    set_enabled(view, true) unless empty_init?
    @model.unsubscribe(self) if @model
    new_model.subscribe(self, :invalidate)
    @model = new_model
    self.invalidate(new_model)
  end

  def set_enabled(a_view, enabled)
    if a_view.is_a? NSControl
      a_view.setEnabled(enabled)
    else
      a_view.subviews.each {|sub| set_enabled(sub, enabled)}
    end
  end

  def model
    return @model if @model
    new_model(null_model)
    @model
  end

end
