require 'test/unit'
require 'configuration'

class ConfigurationTest < Test::Unit::TestCase
  def setup
    @dump = Array.new(0xA0, 0)
    @conf = Configuration.new(nil, @dump)
    @observed_subject = nil
  end

  def action_method(subject)
    @observed_subject = subject
  end

  def test_observer
    @conf.pmd = 2
    assert_nil @observed_subject, "no callback before registration"
    @conf.subscribe(self, :action_method)
    pmd = 3
    @conf.pmd = pmd
    assert_equal pmd, @observed_subject.pmd
  end

  def test_lfo_speed
    lfo_speed = 125
    @dump[0x09] = lfo_speed
    assert_equal lfo_speed, @conf.lfo_speed
  end

  def test_name
    name = "Marimba"
    @conf.name = name
    assert_equal name, @conf.name
  end

  def test_amd
    amd = 127
    @conf.amd = amd
    assert_equal amd, @conf.amd
  end

  def test_lfo_waveform
    wf = "Triangle"
    @conf.lfo_waveform = wf
    assert_equal wf, @conf.lfo_waveform
  end
end
