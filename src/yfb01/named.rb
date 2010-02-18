module Named

  def name
    @data[0..6].inject("") { |result, char| result << char } 
 end

  def name=(name)
    (0..6).to_a.each {|idx| set(idx, 0x7F, (name[idx] || " ").ord)}
  end

end
