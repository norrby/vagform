class ArrayPart
include Enumerable

  def initialize(array, index, stop)
    @origin = array
    @start = index
    @stop = stop
  end

  def [](index)
    index_in_origin = index + @start
    return @origin[index_in_origin] if (@start..@stop).include? index_in_origin
    raise "out of bounds index[#{index}] (index_in_origin[#{index_in_origin}])"
  end

  def []=(index, value)
    index_in_origin = index + @start
    return @origin[index_in_origin]=value if (@start..@stop).include? index_in_origin
    raise "out of bounds index[#{index}] (index_in_origin[#{index_in_origin}])"
  end

  def length
    return to_a.length
  end

  def each
    (@start..@stop).each {|idx| yield @origin[idx]}
  end
end
