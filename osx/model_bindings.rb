module ModelBindings

  def valueForKey(key)
    model.send key
  end

  def setValue(value, forKey:key)
    value = value.to_i if value.class == Float
    value = 1 if value.class == TrueClass
    value = 0 if value.class == FalseClass
    model.send key + "=", value
  end

end
