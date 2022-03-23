
load "~/github/petal-1.3.0/petal.rb"

set_volume! 2.0
set_mixer_control! amp: 1, amp_slide: 0
cps 1; d1; use_bpm get_bpm; live_loop :l0 do use_bpm get_bpm; sync :d0; end

spc = get_seconds_per_cycle

live_loop :l0 do
  sync :d0
end

live_loop :l1, sync: :l0 do
  stop
  m = line(0, 1, steps: 12).mirror.tick
  ps = line(2, 24, steps: 16).mirror.tick
  with_fx :pitch_shift, mix: m, pitch: ps, window_size: 0.2 + rand(0.2) do
    pick = !one_in(8)
    rate = line(0.125, 2, steps: 6).mirror.tick
    loop_chop(:loop_mehackit1, 4 * spc, 1, 0.8, 8, pick, rate)
  end
end

live_loop :l2, sync: :l0 do
  stop
  m = line(0, 1, steps: 16).mirror.tick
  ps = line(2, 24, steps: 16).mirror.tick
  with_fx :pitch_shift, mix: m, pitch: ps, window_size: 0.2 + rand(0.2) do
    pick = !one_in(8)
    rate = line(4, 16, steps: 6).mirror.tick
    loop_chop(:loop_breakbeat, 4 * spc, 1, 0.9, 8, pick, rate)
  end
end

live_loop :l3, sync: :l0 do
  stop
  pick = true
  rate = ring(8,12,10).shuffle.tick
  loop_chop(:loop_amen, 4 * spc, 1, 0.9, 8, pick, 2)
end

def loop_chop(loop_name, duration = 0,
              prob_chop = 0, prob_rev = 0,
              amp = 1.0, pick = false, rate = 1.0)
  if duration == 0
    dur = sample_duration(loop_name)
    rr = 1.0
  else
    dur = duration
    rr = duration / sample_duration(loop_name)
  end
  
  onsets = sample_buffer(loop_name).onset_slices
  onsets = onsets.shuffle if pick
  onsets.each do |onset|
    puts "onset: #{onset}"
    start = onset[:start]
    finish = onset[:finish]
    idx = onset[:index]
    s = dur * (finish - start)
    r =  (one_in(prob_rev) ? -1.0 : 1.0) * rate * rr
    
    in_thread do
      if one_in prob_chop
        d = rrand_i(1, 4)
        sd = s / d
        d.times do
          sample loop_name, onset: idx, amp: 0.25 * amp, rate: r
          sleep sd
        end
      else
        sample loop_name, amp: 1.0 * amp, start: start, finish: finish, rate: r
      end
    end
    sleep s
  end
end
