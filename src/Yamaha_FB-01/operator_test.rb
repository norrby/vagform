# -*- coding: iso-8859-1 -*-
require 'test/unit'
require 'operator'

class OperatorTest < Test::Unit::TestCase
  def setup
    @dump = Array.new(0x08, 0)
    @operator = Operator.new(@dump)
  end

  def test_tl
  end
end
