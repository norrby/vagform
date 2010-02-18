# Provides LFO waveform support.
# Needs a :lfo_waveform_internal to work
module LfoWaveform
  @@LfoWaveforms = ["Sawtooth", "Square", "Triangle", "Sample and Hold"]

  def lfo_waveforms
    return @@LfoWaveforms
  end

  def lfo_waveform=(waveform)
    index_of_provided_wf = @@LfoWaveforms.index(waveform)
    raise ArgumentError, "unknown LFO waveform " + waveform if not index_of_provided_wf
    self.lfo_waveform_no = index_of_provided_wf
  end

  def lfo_waveform
    @@LfoWaveforms[lfo_waveform_no]
  end
end
