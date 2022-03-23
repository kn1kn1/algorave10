
load "~/github/petal-1.3.0/petal.rb"

set_volume! 2.0
set_mixer_control! amp: 1, amp_slide: 0
##| cps 1; d1; use_bpm get_bpm; live_loop :l0 do use_bpm get_bpm; sync :d0; end
bpm 70; d1; use_bpm get_bpm; live_loop :l0 do use_bpm get_bpm; sync :d0; end

rr = scale(:e10, :aeolian).shuffle

live_loop :t1, sync: :d0 do
  
  use_bpm get_bpm * 2
  nn = rr.tick
  pitch = line(2, 12, step: 8).mirror.tick
  16.times do
    n = [2, 2, 2, 2, 4, 4, 8, 16].choose
    pp = rrand(-1,1)
    in_thread do
      with_fx :echo, phase: 0.5 / n, mix: rrand(0.8,1) do
        lb :tri, nn, 0.125, 0.3, pp
      end
    end
    sleep 0.25
  end
end

live_loop :ddd, sync: :d0 do |idxd|
  ##| stop
  use_bpm get_bpm * 2
  i = idxd % 8
  pitch = line(2, 12, step: 8).mirror.tick
  with_fx :rlpf, cutoff: 90 + i * 5, cutoff_slide: 1 do |c|
    [
      [1,0,1,0,0,0,0,0],
      [0,1,0,1,0,0,0,0],
      [0,0,1,0,0,0,0,0],
      [1,0,0,1,0,0,0,0]
    ].each.with_index do |pat, j|
      pat.each.with_index do |kick, k|
        bd if kick == 1
        sd if k == 4
        sleep 0.125
      end
    end
    
    idxd = idxd + 0.5
  end
  ##| end
end