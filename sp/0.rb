load "~/github/petal-1.3.0/petal.rb"

cps 1.0
d9
$spc = get_seconds_per_cycle

use_bpm get_bpm

live_loop :l0 do
  use_bpm get_bpm
  sync :d0
end

def with_pfx(window_size_list = [0.001, 0.005, 0.01], pitch_list = [12])
  ws = window_size_list.choose
  ws = 0.000051 if ws <= 0.00005
  ps = pitch_list.choose
  ps = -72 if ps < -72
  ps = 24 if ps > 24
  with_fx :pitch_shift, pitch: ps, window_size: ws do
    with_fx :distortion do
      yield
    end
  end
end

def tt(amp = 1, pan = 0)
  lb :tri, 120, 0.125, 0.3 * amp, pan
end

def sd(amp = 1)
  with_fx :distortion do
    lb :saw, 100, 0.125, amp
  end
end

def bd(amp = 1)
  lb :beep, 35, 1, amp * 0.5
  lb :fm, 80, 0.125, amp * 1.0
end

def lb(synth, note, dur = 0.1, amp = 0.2, pan=0)
  use_synth synth
  pp = play note, amp: amp, pan: pan,
    release: dur, note_slide_shape: 7
  control pp, note: 12, note_slide: dur
end
